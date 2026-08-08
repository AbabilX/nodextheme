const vscode = require("vscode");

const CLEANUP_FLAG = "muradAmoled.nilkanthaBgCleanupDone.v3";
const THEME_KEY = "[Murad Nilkantha]";
const BG_SECTION_KEYS = [
  "background.editor",
  "background.fullscreen",
  "background.sidebar",
  "background.panel",
  "background.auxiliarybar",
];

/**
 * Detect leftover Nilkantha bird wallpaper paths from older installs.
 * @param {unknown} src
 */
function isNilkanthaBirdImage(src) {
  const value = String(src || "").toLowerCase();
  return (
    value.includes("nilkantha-bird") ||
    (value.includes("murad-amoled") && value.includes("nilkantha"))
  );
}

/**
 * @param {Record<string, unknown>} section
 */
function stripBirdImages(section) {
  if (!section || typeof section !== "object") {
    return { next: section, changed: false, emptied: false };
  }

  const images = section.images;
  if (!Array.isArray(images) || images.length === 0) {
    return { next: section, changed: false, emptied: false };
  }

  const filtered = images.filter((img) => !isNilkanthaBirdImage(img));
  if (filtered.length === images.length) {
    return { next: section, changed: false, emptied: false };
  }

  if (filtered.length === 0) {
    return { next: undefined, changed: true, emptied: true };
  }

  return {
    next: { ...section, images: filtered },
    changed: true,
    emptied: false,
  };
}

/**
 * Remove leftover Nilkantha bg settings written by older extension versions.
 * Does not wipe unrelated background.extension images.
 */
async function removeLeftoverNilkanthaBackground() {
  const config = vscode.workspace.getConfiguration();
  let changed = false;

  const targets = [
    vscode.ConfigurationTarget.Global,
    vscode.ConfigurationTarget.Workspace,
  ];

  for (const target of targets) {
    for (const key of BG_SECTION_KEYS) {
      const inspected = config.inspect(key);
      const current =
        target === vscode.ConfigurationTarget.Global
          ? inspected && inspected.globalValue
          : inspected && inspected.workspaceValue;

      if (!current) {
        continue;
      }

      const { next, changed: sectionChanged } = stripBirdImages(current);
      if (!sectionChanged) {
        continue;
      }

      await config.update(key, next, target);
      changed = true;
    }

    const colorsInspect = config.inspect("workbench.colorCustomizations");
    const currentColors =
      target === vscode.ConfigurationTarget.Global
        ? colorsInspect && colorsInspect.globalValue
        : colorsInspect && colorsInspect.workspaceValue;

    if (!currentColors || !currentColors[THEME_KEY]) {
      continue;
    }

    const globalColors = { ...currentColors };
    const themeColors = { ...globalColors[THEME_KEY] };
    const bg = themeColors["editor.background"];
    if (
      typeof bg === "string" &&
      (bg.toLowerCase() === "#00000000" ||
        bg.toLowerCase() === "#0000" ||
        bg === "transparent")
    ) {
      delete themeColors["editor.background"];
      changed = true;

      if (Object.keys(themeColors).length === 0) {
        delete globalColors[THEME_KEY];
      } else {
        globalColors[THEME_KEY] = themeColors;
      }

      const nextColors =
        Object.keys(globalColors).length > 0 ? globalColors : undefined;
      await config.update("workbench.colorCustomizations", nextColors, target);
    }
  }

  return changed;
}

async function runCleanup({ interactive }) {
  const changed = await removeLeftoverNilkanthaBackground();

  if (!changed) {
    if (interactive) {
      vscode.window.showInformationMessage(
        "No leftover Nilkantha bird background settings found."
      );
    }
    return false;
  }

  const reload = await vscode.window.showInformationMessage(
    "Removed leftover Nilkantha bird background. Reload to restore the default editor.",
    "Reload Window"
  );
  if (reload === "Reload Window") {
    await vscode.commands.executeCommand("workbench.action.reloadWindow");
  }
  return true;
}

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
  context.subscriptions.push(
    vscode.commands.registerCommand(
      "muradAmoled.removeLeftoverBirdBackground",
      () => runCleanup({ interactive: true })
    )
  );

  if (!context.globalState.get(CLEANUP_FLAG)) {
    queueMicrotask(async () => {
      try {
        await runCleanup({ interactive: false });
      } finally {
        await context.globalState.update(CLEANUP_FLAG, true);
      }
    });
  }
}

function deactivate() {}

module.exports = { activate, deactivate };

const vscode = require("vscode");
const path = require("path");

const THEME_LABEL = "Murad Nilkantha";
const BG_EXTENSION_ID = "shalldie.background";
const PROMPT_KEY = "muradAmoled.nilkanthaBgPrompted";

/**
 * Absolute file URI for the bird image shipped inside this extension.
 * Works on any machine after VSIX install (no hardcoded user paths).
 */
function birdImageUri(context) {
  const fsPath = context.asAbsolutePath(path.join("images", "nilkantha-bird.png"));
  return vscode.Uri.file(fsPath).toString();
}

async function ensureBackgroundExtension() {
  if (vscode.extensions.getExtension(BG_EXTENSION_ID)) {
    return true;
  }

  const pick = await vscode.window.showWarningMessage(
    'Nilkantha bird background needs the "background" extension.',
    "Install background",
    "Cancel"
  );

  if (pick !== "Install background") {
    return false;
  }

  try {
    await vscode.commands.executeCommand(
      "workbench.extensions.installExtension",
      BG_EXTENSION_ID
    );
    return true;
  } catch (err) {
    vscode.window.showErrorMessage(
      `Could not install ${BG_EXTENSION_ID}. Install it from the Marketplace, then run the command again.`
    );
    return false;
  }
}

async function enableNilkanthaBackground(context) {
  const ready = await ensureBackgroundExtension();
  if (!ready) {
    return;
  }

  const image = birdImageUri(context);
  const config = vscode.workspace.getConfiguration();

  await config.update("background.enabled", true, vscode.ConfigurationTarget.Global);

  const colorCustom = {
    ...(config.get("workbench.colorCustomizations") || {}),
  };
  colorCustom[`[${THEME_LABEL}]`] = {
    ...(colorCustom[`[${THEME_LABEL}]`] || {}),
    "editor.background": "#00000000",
  };
  await config.update(
    "workbench.colorCustomizations",
    colorCustom,
    vscode.ConfigurationTarget.Global
  );

  await config.update(
    "background.editor",
    {
      useFront: false,
      style: {
        "background-position": "center center",
        "background-repeat": "no-repeat",
        "background-size": "cover",
        opacity: 1,
      },
      styles: [],
      images: [image],
      interval: 0,
      random: false,
    },
    vscode.ConfigurationTarget.Global
  );

  if (config.get("workbench.colorTheme") !== THEME_LABEL) {
    const switchTheme = await vscode.window.showInformationMessage(
      "Bird background bound. Switch to Murad Nilkantha?",
      "Switch theme",
      "Keep current"
    );
    if (switchTheme === "Switch theme") {
      await config.update(
        "workbench.colorTheme",
        THEME_LABEL,
        vscode.ConfigurationTarget.Global
      );
    }
  }

  const reload = await vscode.window.showInformationMessage(
    "Nilkantha bird background enabled. Reload window to apply.",
    "Reload Window"
  );
  if (reload === "Reload Window") {
    await vscode.commands.executeCommand("workbench.action.reloadWindow");
  }
}

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
  context.subscriptions.push(
    vscode.commands.registerCommand(
      "muradAmoled.enableNilkanthaBackground",
      () => enableNilkanthaBackground(context)
    )
  );

  // One-time nudge after install so friends know how to bind the image.
  if (!context.globalState.get(PROMPT_KEY)) {
    queueMicrotask(async () => {
      const pick = await vscode.window.showInformationMessage(
        "Murad AMOLED includes a Nilkantha bird editor background. Enable it?",
        "Enable bird background",
        "Not now"
      );
      await context.globalState.update(PROMPT_KEY, true);
      if (pick === "Enable bird background") {
        await enableNilkanthaBackground(context);
      }
    });
  }
}

function deactivate() {}

module.exports = { activate, deactivate };

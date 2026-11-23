use zed_extension_api::{self as zed, settings::LspSettings, LanguageServerId, Result};

/// The language server's id in extension.toml, also the key for its
/// settings under `lsp` in Zed's settings.json.
const SERVER_ID: &str = "plum-lsp";

const INSTALL_HELP: &str = concat!(
    "Plumlang: `plum` was not found on your PATH, so the language server ",
    "cannot start. Install Plumlang, then restart Zed:\n",
    "\n",
    "  macOS / Linux:  curl -fsSL https://plum.elixpo.com/install.sh | sh\n",
    "  Windows:        irm https://plum.elixpo.com/install.ps1 | iex\n",
    "  Homebrew:       brew install plumlang/tap/plum\n",
    "\n",
    "Or point Zed at it in settings.json: ",
    "{ \"lsp\": { \"plum-lsp\": { \"binary\": { \"path\": \"/path/to/plum\" } } } }\n",
    "More: https://plum.elixpo.com/docs/tools/lsp/",
);

struct PlumExtension;

impl zed::Extension for PlumExtension {
    fn new() -> Self {
        PlumExtension
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        // Optional overrides from settings.json: lsp.plum-lsp.binary.
        let binary = LspSettings::for_worktree(SERVER_ID, worktree)
            .ok()
            .and_then(|settings| settings.binary);
        let (path, arguments, extra_env) = match binary {
            Some(binary) => (binary.path, binary.arguments, binary.env),
            None => (None, None, None),
        };

        let command = match path.or_else(|| worktree.which("plum")) {
            Some(command) => command,
            None => return Err(INSTALL_HELP.to_string()),
        };

        // On macOS and Linux, start the server with the login shell's
        // environment, as a terminal in the project would have it.
        let mut env = match zed::current_platform().0 {
            zed::Os::Mac | zed::Os::Linux => worktree.shell_env(),
            zed::Os::Windows => Vec::new(),
        };
        if let Some(extra_env) = extra_env {
            env.extend(extra_env);
        }

        Ok(zed::Command {
            command,
            args: arguments.unwrap_or_else(|| vec!["lsp".to_string()]),
            env,
        })
    }
}

zed::register_extension!(PlumExtension);

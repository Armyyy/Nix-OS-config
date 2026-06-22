{
  pkgs,
  lib,
  ...
}:
let
  # NixOS-patched (autoPatchelf) browser binaries. Revision: chromium-1217,
  # which corresponds to Playwright 1.59.x.
  browsers = pkgs.playwright-driver.browsers;
in
{
  home.packages = [ browsers ];

  # Universal env so any Playwright invocation (test runner, npx, MCP) finds the
  # Nix-provided browsers instead of trying to download them (which fails on NixOS).
  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    PLAYWRIGHT_NODEJS_PATH = "${pkgs.nodejs}/bin/node";
  };

  # Register the Playwright MCP server globally so Claude Code can drive a browser.
  # Pinned to @playwright/mcp@0.0.69 -> playwright-core 1.59.x to match the
  # nixpkgs playwright-driver browser revision (chromium-1217). Bumping nixpkgs
  # may change that revision -> re-pin the MCP version to the matching minor.
  home.activation.playwrightMcp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CLAUDE_JSON="$HOME/.claude.json"
    if [ -f "$CLAUDE_JSON" ]; then
      ${pkgs.jq}/bin/jq \
        --arg npx "${pkgs.nodejs}/bin/npx" \
        --arg browsers "${browsers}" \
        --arg node "${pkgs.nodejs}/bin/node" \
        '.mcpServers.playwright = {
          "type": "stdio",
          "command": $npx,
          "args": ["-y", "@playwright/mcp@0.0.69", "--isolated", "--browser", "chromium"],
          "env": {
            "PLAYWRIGHT_BROWSERS_PATH": $browsers,
            "PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS": "true",
            "PLAYWRIGHT_NODEJS_PATH": $node
          }
        }' \
        "$CLAUDE_JSON" > "$CLAUDE_JSON.tmp" && mv "$CLAUDE_JSON.tmp" "$CLAUDE_JSON"
    fi
  '';
}

# TravelYalla Agent Kit

This repo packages TravelYalla as a plugin for AI assistants: ChatGPT, Codex and Claude. The plugin includes:

- the live TravelYalla MCP server at `https://mcp.travelyalla.com/mcp`, which provides flight and hotel search
- skills that teach the assistant how to use that server well
- the listing details: name, description, starter prompts, links and icons.

The repo holds no application code. The MCP server lives in `ty-services` (`./mcp`).

## Install

### Claude Code

```text
/plugin marketplace add TravelYalla-org/agent-kit
/plugin install travelyalla@travelyalla
```

The skills then appear as `/travelyalla:find-flights`, `/travelyalla:find-hotels` and so on. Claude also uses them on its own when a request matches.

### Codex CLI

```bash
codex plugin marketplace add TravelYalla-org/agent-kit
```

Then install **TravelYalla** from the Plugins Directory.

### ChatGPT desktop (for local testing)

Clone this repo. The ChatGPT desktop app reads `.agents/plugins/marketplace.json` from it; restart the app, open the Plugins Directory, choose **TravelYalla** and install.

### Claude.ai or any MCP client, without the skills

Add a custom connector with the URL `https://mcp.travelyalla.com/mcp`.

## What's inside

```text
.claude-plugin/marketplace.json     Claude Code catalog
.agents/plugins/marketplace.json    ChatGPT / Codex catalog
plugins/travelyalla/
  plugin.json                       Portable manifest, ChatGPT listing, review cases, Arabic translations
  .claude-plugin/plugin.json        Claude manifest
  mcp.json                          MCP server for ChatGPT / Codex (streamable-http)
  .mcp.json                         MCP server for Claude (http)
  assets/                           icon.png (512×512), logo.png
  skills/
    get-started/                    Onboarding: what TravelYalla can and can't do
    find-flights/                   One-way, round-trip and multi-city search, compare, baggage, booking link
    find-hotels/                    Destination lookup, hotel search, filters, details, booking link
    flexible-dates/                 Cheapest day to fly within a range
    plan-trip/                      Flights plus a matching hotel, total against budget, outline
```

The MCP tools behind the skills are `search-destinations`, `search-flights`, `get-flight-details`, `search-hotels` and `get-hotel-details`.

## Release a new version

1. Bump `version` in **both** `plugins/travelyalla/plugin.json` and `plugins/travelyalla/.claude-plugin/plugin.json`. Claude Code users only receive changes after the version changes.
2. Run `claude plugin validate .` from the repo root.
3. Commit and push. Claude Code and Codex users get the update on their next marketplace update.

## Publish to the ChatGPT and Codex plugin directory

1. Run `scripts/build-chatgpt-zip.sh`. It writes `dist/travelyalla-<version>.zip`, with `plugin.json` at the zip's root. The portal only accepts an update whose `name` matches the existing plugin (`dev-6abd1a1153b48191bd48f35602a19139`, from when it was first created as a connector), so the script sets that name in the zip's copy only.
2. Upload the zip under **Upload new version** in the plugin submission portal. The listing, starter prompts, translations and the 5 positive and 3 negative review test cases are read from `plugin.json`.
3. Verify the `travelyalla.com` domain, add screenshots, and submit for review.

The server is search-only and needs no sign-in, so no reviewer credentials are required.

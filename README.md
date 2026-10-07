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

Add a custom connector with the URL `https://mcp.travelyalla.com/mcp`. Free Claude plans allow one custom connector; Pro, Max, Team and Enterprise allow more. Step-by-step guides: [ChatGPT](https://mcp.travelyalla.com/docs/chatgpt), [Claude](https://mcp.travelyalla.com/docs/claude).

## What's inside

```text
.claude-plugin/marketplace.json     Claude Code catalog
.agents/plugins/marketplace.json    ChatGPT / Codex catalog
plugins/travelyalla/
  plugin.json                       Portable manifest, ChatGPT listing, review cases, Arabic translations
  .claude-plugin/plugin.json        Claude manifest
  mcp.json                          MCP server for ChatGPT / Codex (streamable-http)
  .mcp.json                         MCP server for Claude (http)
  assets/                           icon.png (256×256, also the logo; the portal requires square images)
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

1. Run `scripts/build-chatgpt-zip.sh`. It writes `dist/travelyalla-<version>-workspace.zip`, which updates the existing plugin. That plugin was first created from the MCP connector, so the portal accepts an update only when the zip uses its generated name (`dev-6abd1a1153b48191bd48f35602a19139`) and a `.app.json` that references exactly its connector. The script applies both to the zip only. For a public directory submission ("With MCP"), run `scripts/build-chatgpt-zip.sh directory` instead, which keeps `mcp.json`.
2. Upload the zip under **Upload new version** in the plugin submission portal. The listing, starter prompts, translations, the 5 positive and 3 negative review test cases and the video walkthrough (`review.demo_recording_url`) are read from `plugin.json`.
3. Verify the MCP domain and submit for review. The portal fetches `https://mcp.travelyalla.com/.well-known/openai-apps-challenge`, which the MCP server serves from the `OPENAI_APPS_CHALLENGE` env var.

The server is search-only and needs no sign-in, so no reviewer credentials are required.

## Publish to the Claude directory

Claude's directory reads this repo from GitHub, so there is no ZIP. It follows `main` automatically after approval.

1. In [claude.ai/directory/manage](https://claude.ai/directory/manage), choose **Submit new → Plugin bundle**, with repository `TravelYalla-org/agent-kit` and plugin path `plugins/travelyalla`.
2. Select **Validate**. The listing's privacy link comes from `privacyPolicyUrl` in `.claude-plugin/plugin.json`. The validator warns that Claude Code ignores this field, which is expected.
3. Answer the data-handling questions to match the [privacy policy](https://travelyalla.com/en-WW/privacy-policy): search details (route, dates, travellers, nationality, country) go to TravelYalla and its airline and hotel suppliers, and the plugin isn't intended for under-18s.
4. Separately, choose **Submit new → MCP connector** with `https://mcp.travelyalla.com/mcp`, so claude.ai users can add TravelYalla from the directory without Claude Code.

The MCP endpoint must stay open (no `MCP_TOKEN`): neither directory can send a shared key.

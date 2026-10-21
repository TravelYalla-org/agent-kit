# Claude connector submission: TravelYalla

Answers for claude.ai/directory/manage → **Submit new** → **MCP connector**, one section per portal step.
Checked against the live server on 2026-10-21: 5 tools, all with `title` and `readOnlyHint: true`, no auth, one MCP App resource (`ui://travelyalla/results.html`).

## 1. Connection

- **Server URL:** `https://mcp.travelyalla.com/mcp`
- **Users connect to different URLs:** no

## 2. Tools

These sync automatically. All 5 should appear under **read-only**, and none should be flagged:
`search-flights`, `get-flight-details`, `search-destinations`, `search-hotels`, `get-hotel-details`.

## 3. Listing

- **Server name:** TravelYalla
- **One-liner** (≤200 characters):
  Find cheap flights and hotels with live TravelYalla prices across Egypt, Saudi Arabia and worldwide, then book on travelyalla.com.
- **Description** (≤2,000 characters):
  TravelYalla brings live flight and hotel prices into your Claude conversation, for trips across Egypt, Saudi Arabia, the Gulf and worldwide.

  Search one-way, round-trip and multi-city flights and compare them by price, stops, airline, departure time and baggage allowance. Search hotels by city or hotel name and narrow them by star rating, guest score, price and distance from the city centre, then open a hotel's details for its address, facilities and check-in times.

  Results appear as interactive cards, and every flight and hotel links straight to travelyalla.com to book. Prices follow your nationality and currency. Ask in English or Arabic.

  TravelYalla only searches. It never books, charges or stores payment details inside Claude. No account is needed to connect.
- **Categories (1–5):** Travel. Add a second one from the portal's list only if one fits, such as Lifestyle.
- **Documentation URL:** https://mcp.travelyalla.com/docs/claude
- **Privacy policy URL:** https://travelyalla.com/en-WW/privacy-policy
- **Support contact:** reservation@travelyalla.com (or https://travelyalla.com/en-WW/contact-us)
- **Icon:** `plugins/travelyalla/assets/icon.png` (256×256 PNG). If the portal asks for a larger image, export a 512×512 one from the source logo.
- **URL slug:** `travelyalla` (permanent once published)

### Allowed link URIs

The results UI opens booking links through `ui/open-link`:

- `https://travelyalla.com`
- `https://www.travelyalla.com`

### Carousel screenshots (required: this is an MCP App)

Provide 3–5 PNGs, each at least 1000px wide. Crop each to the result cards only, without the prompt, and add the paired prompt as text. Take them in Claude with the connector added as a custom connector.

| # | Paired prompt |
|---|---|
| 1 | Find the cheapest round-trip flights from Cairo to Dubai next weekend |
| 2 | Show me top-rated hotels in Dubai for 2 adults next weekend |
| 3 | Plan a 5-day trip from Riyadh to Cairo in November |
| 4 | أرخص فنادق ٥ نجوم في مكة الأسبوع القادم |

## 4. Use cases

- **Primary use cases:**
  1. Compare live flight prices for a route and dates, including baggage, stops and airline.
  2. Find hotels in a city for given dates, filtered by stars, guest score, price or distance.
  3. Plan a trip with flights plus a matching hotel and an estimated total in one currency.
  4. Find the cheapest day to fly within a flexible date range.
- **What users need before connecting:** nothing. There's no account, plan or setup. Booking happens on travelyalla.com, where the user signs in or checks out as a guest.
- **Reads or writes:** reads only.

## 5. Company

- **Company name:** TravelYalla
- **Website:** https://travelyalla.com
- **Primary contact:** _your name and email (gets review updates)_

## 6. Authentication

**No authentication.** All data is public travel inventory and prices, and no tool acts on a user account.

## 7. Data handling

- **Underlying API:** your own. The server calls TravelYalla's own booking API (`api/v1`), which aggregates the airline and hotel supplier inventory TravelYalla is contracted to sell.
- **Personal health data:** no.
- **Sponsored content:** no. Results are ranked by price or by the sort the user asks for.

## 8. Test & launch

- **Reviewer access instructions:**
  No account or credentials are needed. In Claude, add a custom connector with the URL `https://mcp.travelyalla.com/mcp`, enable it, and try:
  1. "Find round-trip flights from Dubai to London leaving next Friday and returning Sunday for 1 adult" → `search-flights`
  2. "Tell me the baggage allowance for the cheapest one" → `get-flight-details`
  3. "Show me top-rated hotels in Dubai for 2 adults next weekend" → `search-destinations`, `search-hotels`
  4. "Tell me the check-in time and facilities of the best-rated one" → `get-hotel-details`

  Use dates in the future; past dates return a validation error that explains the problem. Booking links open travelyalla.com, and you don't need to complete a booking.
- **Confirm every tool was run:** run the four prompts above in Claude first, then tick the box.

## 9. Compliance

All seven acknowledgements apply. The connector:

- uses TravelYalla's own API
- moves no money
- generates no AI media
- has no instructions in tool descriptions beyond how to call the tool
- collects no conversation data
- has public docs at mcp.travelyalla.com/docs/claude

## 10. After submitting

Once the connector is listed, pair it with the **Travelyalla** plugin bundle from the same organization. The plugin's `.mcp.json` already points at the same URL.

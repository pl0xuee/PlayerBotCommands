# PlayerBotCommands

A compact World of Warcraft WOTLK 3.3.5 addon UI for sending mod-playerbots chat commands quickly.

## Features

- Compact in-game command panel
- Category-based command groups
- Dynamic command area sizing
- Chat mode controls (AUTO, PARTY, RAID)
- Last sent command status

## Requirements

- World of Warcraft 3.3.5a client
- AzerothCore with mod-playerbots enabled
- Character in a party or raid with bots (for group chat commands)

## Install

### Windows

1. Locate your WoW AddOns folder.
   - Typical path: `C:\World of Warcraft\Interface\AddOns\`
2. Copy the `PlayerBotCommands` folder into `AddOns`.
3. Final path should look like:
   - `C:\World of Warcraft\Interface\AddOns\PlayerBotCommands\`
4. Start the game and enable the addon in the AddOns list.

### Linux

1. Locate your WoW AddOns folder (Wine/Lutris install locations vary).
2. Copy the `PlayerBotCommands` folder into `Interface/AddOns`.
3. Final path should look like:
   - `/path/to/WoW/Interface/AddOns/PlayerBotCommands/`
4. Start the game and enable the addon in the AddOns list.

### macOS

1. Locate your WoW AddOns folder.
   - Typical path: `/Applications/World of Warcraft/Interface/AddOns/`
2. Copy the `PlayerBotCommands` folder into `AddOns`.
3. Final path should look like:
   - `/Applications/World of Warcraft/Interface/AddOns/PlayerBotCommands/`
4. Start the game and enable the addon in the AddOns list.

## Usage

- `/pb` toggles the UI
- Use the mode buttons to choose command destination:
  - `AUTO` selects PARTY/RAID automatically
  - `P` forces PARTY
  - `R` forces RAID

## Notes

- The addon sends commands as chat messages.
- If commands do not execute, verify mod-playerbots command settings and your chat channel context.

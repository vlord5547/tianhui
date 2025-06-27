# Concert Ticket Monitor & Auto-Grabber (React Native)

This Expo-compatible React Native app demonstrates a simple UI for monitoring concert tickets.

## Features

- Home screen showing current monitoring state
- Settings screen to configure monitoring
- Status screen polling the server
- Tailwind CSS styling via `nativewind`
- Components from `shadcn/ui`

## Development

Install dependencies and run in Expo:

```bash
npm install
npx expo start
```

The app expects backend endpoints:

- `POST /api/startListening` – start monitoring
- `GET /api/status` – fetch monitoring status
```

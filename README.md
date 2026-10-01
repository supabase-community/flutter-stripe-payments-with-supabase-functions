# Flutter Stripe Payments with Supabase Functions

This is a Flutter example app, showing how to process payments with Supabase Functions for authenticated customers.

![Demo gif](./demo.gif)

## Setup (Supabase Hosted)

### Create new Supabase project

- [Create a new Supabase project](https://app.supabase.io/)
- Navigate to the [Auth settings](https://app.supabase.io/project/_/auth/settings) and turn off the toggle next to "Enable email confirmations". (Note: this is only for testing. In production please enable this setting!)
- Navigate to the [SQL Editor](https://app.supabase.io/project/_/sql) and run the SQL from the [schema.sql](./schema.sql) file.

### Deploy Edge Function

- Head to the **Edge Functions** menu and click "**Deploy a new function**".
- Copy and paste the code from `./supabase/functions/payment-sheet/index.ts` and paste it into the current selected `index.ts` file opened by default.
  - Change the directory of the second to first lines:

``` ts
import { stripe } from "../_utils/stripe.ts";
import { createOrRetrieveCustomer } from "../_utils/supabase.ts";
```

to:

``` ts
import { stripe } from "./stripe.ts";
import { createOrRetrieveCustomer } from "./supabase.ts";
```

This method works because Supabase hosted Edge Functions do not have access to directories outside of the `index.ts` file, therefore it is better to link the `stripe.ts` and `supabase.ts` modules within the same directory.

- Create a new file `db_types.ts` and copy and paste the code from `./supabase/functions/_utils/db_types.ts`
- Create a new file `stripe.ts` and copy and paste the code from `./supabase/functions/_utils/stripe.ts`
- Create a new file `supabase.ts` and copy and paste the code from `./supabase/functions/_utils/supabase.ts`
- Function name: `payment-sheet`
- Click `Deploy function`
- Disable `Verify JWT with legacy secret` in the **Details** menu of `payment-sheet` Edge Function.
  Otherwise you'll receive `401 Unauthorized` error in your Flutter app when you tap the `Init payment sheet` button.

### Setup env vars

- Set up env vars for Supabase Functions:
  - Go to `Secrets` in the Edge Functions menu, and add:

    |Name|Value|
    |---|---|
    |`STRIPE_SECRET_KEY`|`sk_test_XXX`|

    Note: Supabase environment variables are auto populated from `supabase.ts`

    |Name|Value|
    |---|---|
    |`SUPABASE_URL`|`...`|
    |`SUPABASE_ANON_KEY`|`...`|
    |`SUPABASE_SERVICE_ROLE_KEY`|`...`|
    |`SUPABASE_DB_URL`|`...`|

- Set up env vars for the Flutter app:
  - Open `app/lib/config.dart`
  - Fill in your _public_ Supabase keys from https://app.supabase.io/project/_/settings/api
  - Fill in your _public_ Stripe keys from https://stripe.com/docs/development/quickstart#api-keys

### Test locally

- Run the Flutter app in a separate terminal window:
  - `cd app`
  - `flutter clean`
  - `flutter pub get`
  - `flutter run`
- Make some test moneys 💰🧧💵

---

## Setup (Self-Hosted)

### Supabase Functions

Supabase Functions are written in TypeScript, run via Deno, and deployed with the Supabase CLI. Please [download](https://github.com/supabase/cli#install-the-cli) the latest version of the Supabase CLI, or [upgrade](https://github.com/supabase/cli#install-the-cli) it if you have it already installed.

### Setup env vars

- Set up env vars for Supabase Functions:
  - `cp .env.example .env`
  - Fill in your Stripe API keys from https://stripe.com/docs/development/quickstart#api-keys
- Set up env vars for the Flutter app:
  - Open `app/lib/config.dart`
  - Fill in your _public_ Supabase keys from the `supabase start` output.
    |Name|Value|
    |---|---|
    |`SUPABASE_URL`|`http://127.0.0.1:54321`|
    |`SUPABASE_ANON_KEY`|`sb_publishable_XXX`|
  - Fill in your _public_ Stripe keys from https://stripe.com/docs/development/quickstart#api-keys
    |Name|Value|
    |---|---|
    |`STRIPE_SECRET_KEY`|`sk_test_XXX`|


### Develop locally

- Run `supabase start` (make sure your Docker daemon is running.)

### Create a user

``` bash
curl -X POST http://127.0.0.1:54321/auth/v1/admin/users \
  -H "apikey: sb_secret_xxx" \
  -H "Authorization: Bearer sb_secret_xxx" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "email_confirm": true
  }'
```

### Apply Schema to Local Instance

- Enter into the Supabase local instance via Postgres `psql` and run the SQL from the [schema.sql](./schema.sql) file.

### Run Function as Service

- Run `supabase functions serve --env-file .env payment-sheet`
  - NOTE: no need to specify `SUPABASE_URL` and `SUPABASE_ANON_KEY` as they are automatically supplied for you from the linked project.
- Run the Flutter app in a separate terminal window:
  - `cd app`
  - `flutter clean`
  - `flutter pub get`
  - `flutter run`
- Make some test moneys 💰🧧💵
- Stop local development
  - Kill the "supabase functions serve watcher" (ctrl + c)
  - Run `supabase stop` to stop the Docker containers.

### Deploy

- Set up your secrets
  - Run `supabase secrets set --from-stdin < .env` to set the env vars from your `.env` file.
  - You can run `supabase secrets list` to check that it worked and also to see what other env vars are set by default.
- Deploy the function
  - Within your project root run `supabase functions deploy payment-sheet`

## 👁⚡️👁

\o/ That's it, you can now invoke your Supabase Function via the [`supabase-js`](https://www.npmjs.com/package/@supabase/supabase-js) and [`supabase-dart`](https://pub.dev/packages/supabase) client libraries. (More client libraries coming soon. Check the [supabase-community](https://github.com/supabase-community#client-libraries) org for details).

For more info on Supabase Functions, check out the [docs](https://supabase.com/docs/guides/functions) and the [examples](https://github.com/supabase/supabase/tree/master/examples/edge-functions).

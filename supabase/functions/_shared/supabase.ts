import { createClient, type User } from "@supabase/supabase-js";
import type { Database } from "./database.types.ts";
import { stripe } from "./stripe.ts";

// The secret key bypasses row level security, so it must never leave the server.
const supabaseAdmin = createClient<Database>(
  Deno.env.get("SUPABASE_URL") ?? "",
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
);

export async function getUser(authorization: string): Promise<User | null> {
  const token = authorization.replace(/^Bearer /, "");
  const { data } = await supabaseAdmin.auth.getUser(token);
  return data.user;
}

export async function createOrRetrieveCustomer(user: User): Promise<string> {
  const { data: existing } = await supabaseAdmin
    .from("customers")
    .select("stripe_customer_id")
    .eq("id", user.id)
    .maybeSingle()
    .throwOnError();
  if (existing?.stripe_customer_id) {
    return existing.stripe_customer_id;
  }

  const customer = await stripe.customers.create(
    { email: user.email, metadata: { supabase_user_id: user.id } },
    { idempotencyKey: `customer-${user.id}` },
  );
  await supabaseAdmin
    .from("customers")
    .upsert({ id: user.id, stripe_customer_id: customer.id })
    .throwOnError();
  return customer.id;
}

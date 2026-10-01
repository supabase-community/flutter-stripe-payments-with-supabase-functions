import { stripe } from "../_shared/stripe.ts";
import { createOrRetrieveCustomer, getUser } from "../_shared/supabase.ts";

function json(body: unknown, status = 200): Response {
  return Response.json(body, { status });
}

Deno.serve(async (request) => {
  const authorization = request.headers.get("Authorization");
  const user = authorization ? await getUser(authorization) : null;
  if (!user) {
    return json({ error: "Sign in to start a payment" }, 401);
  }

  try {
    const customer = await createOrRetrieveCustomer(user);
    const customerSession = await stripe.customerSessions.create({
      customer,
      components: {
        mobile_payment_element: {
          enabled: true,
          features: {
            payment_method_save: "enabled",
            payment_method_redisplay: "enabled",
            payment_method_remove: "enabled",
          },
        },
      },
    });
    const paymentIntent = await stripe.paymentIntents.create({
      amount: 1099,
      currency: "usd",
      customer,
    });

    return json({
      paymentIntent: paymentIntent.client_secret,
      customer,
      customerSession: customerSession.client_secret,
    });
  } catch (error) {
    console.error(error);
    return json({ error: "Could not create the payment" }, 500);
  }
});

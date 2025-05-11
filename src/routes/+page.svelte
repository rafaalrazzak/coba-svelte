<script lang="ts">
  import { onMount } from "svelte";

  let message: string = "";
  let error: string = "";

  // Fetch message from the server
  onMount(async () => {
    try {
      const response = await fetch(`${import.meta.env.VITE_API_URL}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
        },
      });

      if (response.ok) {
        const data = await response.json();
        message = data.result.message;
      } else {
        error = `Error: ${response.status} ${response.statusText}`;
        console.error("Failed to fetch message:", response.statusText);
      }
    } catch (e) {
      error = e instanceof Error ? e.message : "Unknown error occurred";
      console.error("Exception while fetching message:", error);
    }
  });
</script>

<h1>Welcome to SvelteKit</h1>
{#if error}
  <p class="error">{error}</p>
{:else}
  <p>{message || "Loading..."}</p>
{/if}
<p>
  Visit <a href="https://svelte.dev/docs/kit">svelte.dev/docs/kit</a> to read the
  documentation
</p>

<style>
  .error {
    color: red;
  }
</style>

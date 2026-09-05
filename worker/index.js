export default {
  async fetch(request) {
    return new Response("Hello, from Terraform + Cloudflare CI/CD!");
  },
};
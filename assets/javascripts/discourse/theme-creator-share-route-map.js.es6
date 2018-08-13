export default function() {
  this.route("theme-share", { path: "theme/:username/:slug" });
  this.route("theme-share-key", { path: "theme/:theme_id" });
}

export default {
  resource: "user",
  path: "u/:username",
  map() {
    this.route("themes", function() {
      this.route("show", { path: "/:theme_id" });
      this.route("edit", { path: "/:theme_id/:target/:field_name/edit" });
      this.route("colors", { path: "/:theme_id/colors/:color_scheme_id" });
    });
  }
};

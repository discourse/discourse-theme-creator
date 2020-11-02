import DiscourseRoute from "discourse/routes/discourse";

export default DiscourseRoute.extend({
  serialize(model) {
    return {
      theme_id: model.get("theme_id"),
      id: model.get("id"),
    };
  },

  model(params) {
    const schemes = this.modelFor("user.themes").get("colorSchemes");

    const model = schemes.findBy("id", parseInt(params.color_scheme_id, 10));

    if (!model || model.theme_id !== parseInt(params.theme_id, 10)) {
      this.replaceWith("user.themes.index");
    }

    return model;
  },
});

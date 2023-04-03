import DiscourseRoute from "discourse/routes/discourse";

export default class UserThemesShow extends DiscourseRoute {
  serialize(model) {
    return { theme_id: model.get("id") };
  }

  model(params) {
    const all = this.modelFor("user.themes");
    const model = all.findBy("id", parseInt(params.theme_id, 10));
    return model ? model : this.replaceWith("user.themes.index");
  }

  setupController(controller, model) {
    controller.set("model", model);
    const parentController = this.controllerFor("user.themes");
    parentController.set("editingTheme", false);
    controller.set("allThemes", parentController.get("model"));

    const colorSchemes = parentController
      .get("model.colorSchemes")
      .filterBy("theme_id", model.get("id"));
    colorSchemes.unshift(
      parentController.get("model.colorSchemes").findBy("id", null)
    );
    controller.set("colorSchemes", colorSchemes);
    controller.set("colorSchemeId", model.get("color_scheme_id"));

    controller.set("advancedOverride", false);
  }
}

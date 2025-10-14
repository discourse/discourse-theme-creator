import DiscourseRoute from "discourse/routes/discourse";

export default class UserThemesShowSchema extends DiscourseRoute {
  async model(params) {
    const all = this.modelFor("user.themes");
    const theme = all.findBy("id", parseInt(params.theme_id, 10));
    const setting = theme.settings.findBy("setting", params.setting_name);

    await setting.loadMetadata(theme.id);

    return {
      theme,
      setting,
    };
  }
}

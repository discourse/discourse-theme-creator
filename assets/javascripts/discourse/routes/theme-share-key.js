import { ajax } from "discourse/lib/ajax";
import DiscourseRoute from "discourse/routes/discourse";

export default class ThemeShareKey extends DiscourseRoute {
  templateName = "theme-share";

  async model(params) {
    const response = await ajax(`/theme/${params.theme_id}.json`);
    return response.theme;
  }
}

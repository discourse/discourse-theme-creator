import { ajax } from "discourse/lib/ajax";
import DiscourseRoute from "discourse/routes/discourse";

export default class ThemeShare extends DiscourseRoute {
  async model(params) {
    const response = await ajax(
      `/theme/${params.username}/${params.slug}.json`
    );
    return response.theme;
  }
}

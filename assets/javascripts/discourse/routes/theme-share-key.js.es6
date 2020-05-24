import showModal from "discourse/lib/show-modal";
import { ajax } from "discourse/lib/ajax";
import DiscourseRoute from "discourse/routes/discourse";

export default DiscourseRoute.extend({
  model(params) {
    return ajax(`/theme/${params.theme_id}.json`).then(response => {
      return response["theme"];
    });
  },

  afterModel(model) {
    this.replaceWith("discovery.latest").then(() => {
      Ember.run.next(() =>
        showModal("user-themes-view-modal", { model: model })
      );
    });
  }
});

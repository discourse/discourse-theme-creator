import ModalFunctionality from "discourse/mixins/modal-functionality";
import { default as computed } from "ember-addons/ember-computed-decorators";
import { ajax } from "discourse/lib/ajax";

export default Ember.Controller.extend(ModalFunctionality, {
  @computed("model.id")
  postURL(id) {
    return `${Discourse.BaseUri}/user_themes/${id}/view`;
  },

  actions: {
    view() {
      if (!this.get("session.csrfToken")) {
        ajax(Discourse.getURL("/session/csrf"), { cache: false }).then(
          result => {
            this.set("session.csrfToken", result.csrf);
            Ember.run.next(() => $("#view-theme-form").submit());
          }
        );
      } else {
        $("#view-theme-form").submit();
      }
    },
    download() {
      document.location = `${Discourse.BaseUri}/user_themes/${this.model.id}`;
    },
    cancel() {
      this.send("closeModal");
    }
  }
});

import ModalFunctionality from "discourse/mixins/modal-functionality";
import discourseComputed from "discourse-common/utils/decorators";

export default Ember.Controller.extend(ModalFunctionality, {
  userThemes: Ember.inject.controller("user.themes"),

  @discourseComputed("model.share_slug")
  slugUnique(slug) {
    const existingSlugs = this.get("userThemes.model").map((theme) => {
      if (theme.get("id") !== this.get("model.id")) {
        return theme.get("share_slug");
      }
    });

    return !existingSlugs.some((other_slug) => {
      return other_slug === slug;
    });
  },

  @discourseComputed("model.share_slug")
  slugValid(slug) {
    if (slug == null) {
      return false;
    }
    return slug.match(/^[a-z0-9_-]+$/i);
  },

  @discourseComputed("slugValid", "slugUnique")
  saveDisabled(slugValid, slugUnique) {
    return !slugValid || !slugUnique;
  },

  actions: {
    share() {
      this.get("model").saveChanges("share_slug", "share_destination");
    },

    stopSharing() {
      this.set("model.share_slug", null);
      this.get("model").saveChanges("share_slug");
    },

    startEditingSlug() {
      this.set("oldSlug", this.get("model.share_slug"));
      this.set("oldDestination", this.get("model.share_destination"));
      this.set("editingSlug", true);
    },
    cancelEditingSlug() {
      this.set("model.share_slug", this.get("oldSlug"));
      this.set("model.share_destination", this.get("oldDestination"));
      this.set("editingSlug", false);
    },
    finishedEditingSlug() {
      this.get("model").saveChanges("share_slug", "share_destination");
      this.set("editingSlug", false);
    },
  },
});

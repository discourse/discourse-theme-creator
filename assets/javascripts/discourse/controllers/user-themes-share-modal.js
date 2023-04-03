import Controller, { inject as controller } from "@ember/controller";
import ModalFunctionality from "discourse/mixins/modal-functionality";
import discourseComputed from "discourse-common/utils/decorators";
import { action } from "@ember/object";

export default class UserThemesShareModal extends Controller.extend(
  ModalFunctionality
) {
  userThemes = controller("user.themes");

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
  }

  @discourseComputed("model.share_slug")
  slugValid(slug) {
    if (slug == null) {
      return false;
    }
    return slug.match(/^[a-z0-9_-]+$/i);
  }

  @discourseComputed("slugValid", "slugUnique")
  saveDisabled(slugValid, slugUnique) {
    return !slugValid || !slugUnique;
  }

  @action
  share() {
    this.get("model").saveChanges("share_slug", "share_destination");
  }

  @action
  stopSharing() {
    this.set("model.share_slug", null);
    this.get("model").saveChanges("share_slug");
  }

  @action
  startEditingSlug() {
    this.set("oldSlug", this.get("model.share_slug"));
    this.set("oldDestination", this.get("model.share_destination"));
    this.set("editingSlug", true);
  }

  @action
  cancelEditingSlug() {
    this.set("model.share_slug", this.get("oldSlug"));
    this.set("model.share_destination", this.get("oldDestination"));
    this.set("editingSlug", false);
  }

  @action
  finishedEditingSlug() {
    this.get("model").saveChanges("share_slug", "share_destination");
    this.set("editingSlug", false);
  }
}

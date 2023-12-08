import Component from "@glimmer/component";
import { action } from "@ember/object";
import { getOwner } from "@ember/application";
import { tracked } from "@glimmer/tracking";

export default class UserThemesShareModal extends Component {
  @tracked oldSlug;
  @tracked oldDestination;
  @tracked editingSlug = false;

  themesController = getOwner(this).lookup("controller:user.themes");

  get slugUnique() {
    const existingSlugs = this.themesController.model.map((theme) => {
      if (theme.get("id") !== this.args.model.id) {
        return theme.get("share_slug");
      }
    });

    return !existingSlugs.some((other_slug) => {
      return other_slug === this.args.model.get("share_slug");
    });
  }

  get slugValid() {
    return this.args.model.get("share_slug")?.match(/^[a-z0-9_-]+$/i);
  }

  get saveDisabled() {
    return !this.slugValid || !this.slugUnique;
  }

  @action
  share() {
    this.args.model.saveChanges("share_slug", "share_destination");
  }

  @action
  stopSharing() {
    this.set("model.share_slug", null);
    this.args.model.saveChanges("share_slug");
  }

  @action
  startEditingSlug() {
    this.oldSlug = this.args.model.share_slug;
    this.oldDestination = this.args.model.share_destination;
    this.editingSlug = true;
  }

  @action
  cancelEditingSlug() {
    this.args.model.set("share_slug", this.oldSlug);
    this.args.model.set("share_destination", this.oldDestination);
    this.editingSlug = false;
  }

  @action
  finishedEditingSlug() {
    this.args.model.saveChanges("share_slug", "share_destination");
    this.editingSlug = false;
  }
}

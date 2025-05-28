import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { getOwner } from "@ember/application";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import icon from "discourse/helpers/d-icon";
import htmlSafe from "discourse/helpers/html-safe";
import withEventValue from "discourse/helpers/with-event-value";
import { i18n } from "discourse-i18n";

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
    this.args.model.set("share_slug", null);
    this.args.model.saveChanges("share_slug");
  }

  @action
  startEditingSlug(event) {
    event.preventDefault();
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

  <template>
    <DModal
      id="theme-creator-share-modal"
      @title={{i18n "theme_creator.share_theme"}}
      @closeModal={{@closeModal}}
    >
      {{#if @model.can_share}}
        {{#if @model.is_shared}}
          <p>{{i18n "theme_creator.shared_at"}}</p>

          {{#if this.editingSlug}}
            <code>
              {{@model.base_share_url}}
              <input
                type="text"
                value={{@model.share_slug}}
                placeholder="/"
                {{on "input" (withEventValue (fn (mut @model.share_slug)))}}
              />
            </code>

            <DButton
              @action={{this.finishedEditingSlug}}
              class="btn-primary btn-small submit-edit"
              @icon="check"
              @disabled={{this.saveDisabled}}
            />
            <DButton
              @action={{this.cancelEditingSlug}}
              class="btn-small cancel-edit"
              @icon="xmark"
            />

            <p>{{i18n "theme_creator.share_destination"}}</p>

            <code>
              {{@model.base_destination_url}}
              <input
                type="text"
                value={{@model.share_destination}}
                placeholder="/"
                {{on
                  "change"
                  (withEventValue (fn (mut @model.share_destination)))
                }}
              />
            </code>

            <DButton
              @action={{this.finishedEditingSlug}}
              class="btn-primary btn-small submit-edit"
              @icon="check"
              @disabled={{this.saveDisabled}}
            />
            <DButton
              @action={{this.cancelEditingSlug}}
              class="btn-small cancel-edit"
              @icon="xmark"
            />
          {{else}}
            <code>
              {{@model.base_share_url}}{{@model.share_slug}}
              <a href {{on "click" this.startEditingSlug}}>{{icon "pencil"}}</a>
            </code>

            <p>{{i18n "theme_creator.share_destination"}}</p>

            <code>
              {{@model.base_destination_url}}
              {{@model.share_destination}}
              <a href {{on "click" this.startEditingSlug}}>{{icon "pencil"}}</a>
            </code>
          {{/if}}

          <p>
            <DButton
              @action={{this.stopSharing}}
              @icon="circle-xmark"
              class="btn-danger btn-large"
              @label="theme_creator.stop_sharing"
            />
          </p>
        {{else}}
          <p>{{i18n "theme_creator.share_instructions"}}</p>

          <code>
            {{@model.base_share_url}}
            <input
              type="text"
              value={{@model.share_slug}}
              placeholder="/"
              {{on "input" (withEventValue (fn (mut @model.share_slug)))}}
            />
          </code>

          <p>{{i18n "theme_creator.share_destination_instructions"}}</p>

          <code>
            {{@model.base_destination_url}}
            <input
              type="text"
              value={{@model.share_destination}}
              placeholder="/"
              {{on
                "input"
                (withEventValue (fn (mut @model.share_destination)))
              }}
            />
          </code>

          <p>
            <DButton
              @action={{this.share}}
              @icon="users"
              class="btn-primary btn-large"
              @label="theme_creator.start_sharing"
              @disabled={{this.saveDisabled}}
            />
          </p>
        {{/if}}
      {{else}}
        <div class="share_unavailable">
          <h1 class="large_theme_share_icon">{{icon "users"}}</h1>

          <p class="theme_share_unavailable">
            {{htmlSafe (i18n "theme_creator.share_unavailable")}}
          </p>
        </div>
      {{/if}}
    </DModal>
  </template>
}

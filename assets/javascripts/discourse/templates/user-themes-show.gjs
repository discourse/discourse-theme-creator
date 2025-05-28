import { array, concat, fn, hash } from "@ember/helper";
import { LinkTo } from "@ember/routing";
import RouteTemplate from "ember-route-template";
import DButton from "discourse/components/d-button";
import TextField from "discourse/components/text-field";
import icon from "discourse/helpers/d-icon";
import formatDate from "discourse/helpers/format-date";
import routeAction from "discourse/helpers/route-action";
import { i18n } from "discourse-i18n";
import ComboBox from "select-kit/components/combo-box";
import ColorSchemeEditor from "../components/color-scheme-editor";
import ThemeMetadataField from "../components/theme-metadata-field";
import UserThemeSettingEditor from "../components/user-theme-setting-editor";
import UserThemeTranslation from "../components/user-theme-translation";

export default RouteTemplate(
  <template>
    <div class="show-current-style">
      <h1>
        {{#if @controller.editingName}}
          <TextField @value={{@controller.model.name}} @autofocus="true" />

          <DButton
            @action={{@controller.finishedEditingName}}
            @icon="check"
            class="btn-primary btn-small submit-edit"
          />
          <DButton
            @action={{@controller.cancelEditingName}}
            @icon="xmark"
            class="btn-small cancel-edit"
          />
        {{else}}
          {{@controller.model.name}}

          <a href {{@controller.startEditingName}}>
            {{icon "pencil"}}
          </a>
        {{/if}}
      </h1>

      {{#if @controller.model.is_shared}}
        {{#if @controller.model.can_share}}
          <div class="control-unit share-information">
            {{i18n "theme_creator.shared_at"}}

            <code>
              <a
                target="_blank"
                rel="noopener noreferrer"
                href={{concat
                  @controller.model.base_share_url
                  @controller.model.share_slug
                }}
              >
                {{@controller.model.base_share_url}}{{@controller.model.share_slug}}
              </a>
            </code>

            <a href {{@controller.shareModal}}>
              {{icon "pencil"}}
            </a>
          </div>
        {{/if}}
      {{/if}}

      {{#each @controller.model.errors as |error|}}
        <div class="alert alert-error">
          <button type="button" class="close" data-dismiss="alert">
            ×
          </button>
          {{error}}
        </div>
      {{/each}}

      {{#unless @controller.model.enabled}}
        <div class="alert alert-error">
          {{i18n "admin.customize.theme.required_version.error"}}
          {{#if @controller.model.remote_theme.minimum_discourse_version}}
            {{i18n
              "admin.customize.theme.required_version.minimum"
              version=@controller.model.remote_theme.minimum_discourse_version
            }}
          {{/if}}
          {{#if @controller.model.remote_theme.maximum_discourse_version}}
            {{i18n
              "admin.customize.theme.required_version.maximum"
              version=@controller.model.remote_theme.maximum_discourse_version
            }}
          {{/if}}
        </div>
      {{/unless}}

      {{#if @controller.model.remote_theme}}
        {{#if @controller.model.remote_theme.remote_url}}
          <a
            class="remote-url"
            href={{@controller.model.remote_theme.remote_url}}
          >
            {{i18n "admin.customize.theme.source_url"}}
            {{icon "link"}}
          </a>
        {{/if}}
        {{#if @controller.model.remote_theme.about_url}}
          <a
            class="url about-url"
            href={{@controller.model.remote_theme.about_url}}
          >
            {{i18n "admin.customize.theme.about_theme"}}
            {{icon "link"}}
          </a>
        {{/if}}
        {{#if @controller.model.remote_theme.license_url}}
          <a
            class="url license-url"
            href={{@controller.model.remote_theme.license_url}}
          >
            {{i18n "admin.customize.theme.license"}}
            {{icon "link"}}
          </a>
        {{/if}}

        {{#if @controller.model.description}}
          <span class="theme-description">
            {{@controller.model.description}}
          </span>
        {{/if}}

        <span class="metadata">
          {{#if @controller.model.remote_theme.authors}}
            <span class="authors">
              <span class="heading">
                {{i18n "admin.customize.theme.authors"}}
              </span>
              {{@controller.model.remote_theme.authors}}
            </span>
          {{/if}}
          {{#if @controller.model.remote_theme.theme_version}}
            <span class="version">
              <span class="heading">
                {{i18n "admin.customize.theme.version"}}
              </span>
              {{@controller.model.remote_theme.theme_version}}
            </span>
          {{/if}}
        </span>

        {{#if @controller.model.remote_theme.is_git}}
          <div class="control-unit">
            {{#if @controller.showRemoteError}}
              <div class="error-message">
                {{icon "triangle-exclamation"}}
                {{i18n "admin.customize.theme.repo_unreachable"}}
              </div>
              <div class="raw-error">
                <code>
                  {{@controller.model.remoteError}}
                </code>
              </div>
            {{/if}}

            {{#if @controller.model.remote_theme.commits_behind}}
              <DButton
                @action={{@controller.updateToLatest}}
                @icon="download"
                @label="admin.customize.theme.update_to_latest"
                class="btn-primary"
              />
            {{else}}
              <DButton
                @action={{@controller.checkForThemeUpdates}}
                @icon="arrows-rotate"
                @label="admin.customize.theme.check_for_updates"
                class="btn-default"
              />
            {{/if}}

            <span class="status-message">
              {{#if @controller.updatingRemote}}
                {{i18n "admin.customize.theme.updating"}}
              {{else}}
                {{#if @controller.model.remote_theme.commits_behind}}
                  {{i18n
                    "admin.customize.theme.commits_behind"
                    count=@controller.model.remote_theme.commits_behind
                  }}

                  {{#if @controller.model.remote_theme.github_diff_link}}
                    <a href={{@controller.model.remote_theme.github_diff_link}}>
                      {{i18n "admin.customize.theme.compare_commits"}}
                    </a>
                  {{/if}}
                {{else}}
                  {{#unless @controller.showRemoteError}}
                    {{i18n "admin.customize.theme.up_to_date"}}
                    {{formatDate
                      @controller.model.remote_theme.updated_at
                      leaveAgo="true"
                    }}
                  {{/unless}}
                {{/if}}
              {{/if}}
            </span>
          </div>
        {{/if}}
      {{/if}}

      {{#if @controller.showAdvanced}}
        <div class="control-unit">
          <div class="mini-title">
            {{#if @controller.model.component}}
              {{i18n "theme_creator.component"}}
            {{else}}
              {{i18n "theme_creator.theme"}}
            {{/if}}
          </div>

          <div class="description">
            {{#if @controller.model.component}}
              {{i18n "theme_creator.is_a_component"}}
            {{else}}
              {{i18n "theme_creator.is_a_theme"}}
            {{/if}}
          </div>

          <div class="control">
            {{#if @controller.model.component}}
              <DButton
                @action={{@controller.switchType}}
                @label="theme_creator.convert_to_theme"
                @icon={{@controller.convertIcon}}
                @title={{@controller.convertTooltip}}
                class="btn-default btn-normal"
              />
            {{else}}
              <DButton
                @action={{@controller.switchType}}
                @label="theme_creator.convert_to_component"
                @icon={{@controller.convertIcon}}
                @title={{@controller.convertTooltip}}
                class="btn-default btn-normal"
              />
            {{/if}}
          </div>
        </div>

        <div class="control-unit metadata">
          <div class="mini-title">
            {{i18n "theme_creator.metadata"}}
          </div>

          <ThemeMetadataField
            @icon="link"
            @label="theme_creator.about_url"
            @value={{@controller.model.remote_theme.about_url}}
            @save={{@controller.saveMetadata}}
          />
          <ThemeMetadataField
            @icon="link"
            @label="theme_creator.license_url"
            @value={{@controller.model.remote_theme.license_url}}
            @save={{@controller.saveMetadata}}
          />
          <ThemeMetadataField
            @icon="users"
            @label="theme_creator.authors"
            @value={{@controller.model.remote_theme.authors}}
            @save={{@controller.saveMetadata}}
          />
          <ThemeMetadataField
            @icon="circle-info"
            @label="theme_creator.theme_version"
            @value={{@controller.model.remote_theme.theme_version}}
            @save={{@controller.saveMetadata}}
          />
          <ThemeMetadataField
            @icon="arrow-left"
            @label="theme_creator.minimum_discourse_version"
            @value={{@controller.model.remote_theme.minimum_discourse_version}}
            @save={{@controller.saveMetadata}}
          />
          <ThemeMetadataField
            @icon="arrow-right"
            @label="theme_creator.maximum_discourse_version"
            @value={{@controller.model.remote_theme.maximum_discourse_version}}
            @save={{@controller.saveMetadata}}
          />
        </div>

        {{#unless @controller.model.component}}
          <div class="control-unit">
            <div class="mini-title">
              {{i18n "admin.customize.theme.color_scheme"}}
            </div>

            <div class="description">
              {{i18n "admin.customize.theme.color_scheme_select"}}
            </div>

            <div class="control">
              <ComboBox
                @content={{@controller.colorSchemes}}
                @value={{@controller.colorSchemeId}}
                @icon="paintbrush"
                @options={{hash filterable=true}}
              />
              {{#if @controller.colorSchemeChanged}}
                <DButton
                  @action={{@controller.changeScheme}}
                  @icon="check"
                  class="btn-primary submit-edit"
                />
                <DButton
                  @action={{@controller.cancelChangeScheme}}
                  @icon="xmark"
                  class="btn-default cancel-edit"
                />
              {{else}}
                <LinkTo
                  @route="user.themes.colors"
                  @models={{array
                    @controller.model.id
                    @controller.model.color_scheme_id
                  }}
                  @disabled={{@controller.colorSchemeEditDisabled}}
                  title="theme_creator.edit_color_scheme"
                  class="no-text"
                >
                  {{icon "pencil"}}
                </LinkTo>
                <DButton
                  @action={{@controller.destroyColorScheme}}
                  @title="theme_creator.delete_color_scheme"
                  @icon="trash-can"
                  @disabled={{@controller.colorSchemeEditDisabled}}
                  class="btn-danger"
                />
              {{/if}}
            </div>

            <DButton
              @action={{@controller.createColorScheme}}
              @label={{if
                @controller.creatingColorScheme
                "theme_creator.adding_color_scheme"
                "theme_creator.add_color_scheme"
              }}
              @icon="plus"
              @disabled={{@controller.creatingColorScheme}}
            />
          </div>
        {{/unless}}

        <div class="control-unit">
          <div class="mini-title">
            {{i18n "admin.customize.theme.css_html"}}
          </div>

          {{#if @controller.model.hasEditedFields}}
            <div class="description">
              {{i18n "admin.customize.theme.custom_sections"}}
            </div>

            <ul>
              {{#each @controller.editedFieldsFormatted as |field|}}
                <li>
                  {{field}}
                </li>
              {{/each}}
            </ul>
          {{else}}
            <div class="description">
              {{i18n "admin.customize.theme.edit_css_html_help"}}
            </div>
          {{/if}}

          <DButton
            @action={{@controller.editTheme}}
            @label="admin.customize.theme.edit_css_html"
            class="btn-default edit"
          />
        </div>

        <div class="control-unit">
          <div class="mini-title">
            {{i18n "admin.customize.theme.uploads"}}
          </div>

          {{#if @controller.model.uploads}}
            <ul class="removable-list">
              {{#each @controller.model.uploads as |upload|}}
                <li>
                  <span class="col">
                    ${{upload.name}}:
                    <a
                      href={{upload.url}}
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      {{upload.filename}}
                    </a>
                  </span>

                  <span class="col">
                    <DButton
                      @action={{fn @controller.removeUpload upload}}
                      @icon="xmark"
                      class="second btn-default cancel-edit"
                    />
                  </span>
                </li>
              {{/each}}
            </ul>
          {{else}}
            <div class="description">
              {{i18n "admin.customize.theme.no_uploads"}}
            </div>
          {{/if}}

          <DButton
            @action={{@controller.addUploadModal}}
            @icon="plus"
            @label="admin.customize.theme.add"
            class="btn-default"
          />
        </div>

        {{#if @controller.hasSettings}}
          <div class="control-unit">
            <div class="mini-title">
              {{i18n "admin.customize.theme.theme_settings"}}
            </div>

            <section class="form-horizontal theme settings">
              {{#each @controller.settings as |setting|}}
                <UserThemeSettingEditor
                  @setting={{setting}}
                  @model={{@controller.model}}
                  class="theme-setting"
                />
              {{/each}}
            </section>
          </div>
        {{/if}}

        {{#if @controller.hasTranslations}}
          <div class="control-unit">
            <div class="mini-title">
              {{i18n "admin.customize.theme.theme_translations"}}
            </div>

            <section class="form-horizontal theme settings translations">
              {{#each @controller.translations as |translation|}}
                <UserThemeTranslation
                  @translation={{translation}}
                  @model={{@controller.model}}
                  class="theme-translation"
                />
              {{/each}}
            </section>
          </div>
        {{/if}}
      {{else}}
        {{#if @controller.hasQuickColorScheme}}
          <ColorSchemeEditor @colors={{@controller.quickColorScheme.colors}} />
        {{else}}
          <div class="control-unit">
            <DButton
              @action={{@controller.createColorScheme}}
              @label={{if
                @controller.creatingColorScheme
                "theme_creator.adding_color_scheme"
                "theme_creator.add_color_scheme"
              }}
              @icon="plus"
              @disabled={{@controller.creatingColorScheme}}
              class="btn-primary"
            />
            <DButton
              @action={{@controller.showAdvancedAction}}
              @icon="gear"
              @label="theme_creator.show_advanced"
            />
          </div>
        {{/if}}
      {{/if}}
      <div class="theme-controls">
        {{#if @controller.quickColorScheme}}
          <DButton
            @action={{@controller.saveQuickColorScheme}}
            @disabled={{@controller.isSaving}}
            class="btn-primary"
          >
            {{@controller.saveButtonText}}
          </DButton>
        {{/if}}

        <DButton
          @action={{@controller.shareModal}}
          @label="theme_creator.share"
          @icon="users"
          class="btn-primary"
        />

        {{#if @controller.quickColorScheme}}
          <DButton
            @action={{@controller.showAdvancedAction}}
            @icon="gear"
            @label="theme_creator.show_advanced"
          />
        {{else if @controller.showAdvanced}}
          <DButton
            @action={{routeAction "editLocalModal"}}
            @icon="pencil"
            @label="theme_creator.edit_local"
          />
        {{/if}}

        {{#unless @controller.hidePreview}}
          <a
            href={{@controller.previewUrl}}
            title={{i18n "theme_creator.explain_preview"}}
            target="_blank"
            rel="noopener noreferrer"
            class="btn btn-icon-text"
          >
            {{icon "desktop"}}
            <span class="d-button-label">
              {{i18n "theme_creator.preview"}}
            </span>
          </a>
        {{/unless}}

        <a
          href={{@controller.downloadUrl}}
          target="_blank"
          rel="noopener noreferrer"
          class="btn btn-icon-text"
        >
          {{icon "download"}}
          {{i18n "admin.export_json.button_text"}}
        </a>

        <DButton
          @action={{@controller.destroy}}
          @label="theme_creator.delete"
          @icon="trash-can"
          class="btn-danger"
        />
      </div>
    </div>
  </template>
);

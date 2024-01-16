import { url } from "discourse/lib/computed";
import ThemeSettingEditor from "admin/components/theme-setting-editor";

export default class UserThemeSettingEditor extends ThemeSettingEditor {
  @url("model.id", "/user_themes/%@/setting") updateUrl;
}

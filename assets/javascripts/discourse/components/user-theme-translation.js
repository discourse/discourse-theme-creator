import { url } from "discourse/lib/computed";
import ThemeTranslation from "admin/components/theme-translation";

export default class UserThemeTranslation extends ThemeTranslation {
  @url("model.id", "/user_themes/%@") updateUrl;
}

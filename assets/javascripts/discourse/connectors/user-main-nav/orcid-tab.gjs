import Component from "@glimmer/component";
import { LinkTo } from "@ember/routing";
import { i18n } from "discourse-i18n";
import icon from "discourse-common/helpers/d-icon";

export default class OrcidTab extends Component {
  get hasOrcid() {
    // Profil sahibinin custom_field'larına erişim
    return !!this.args.outletArgs.model.user_fields?.["3"];
  }

  <template>
    {{#if this.hasOrcid}}
      <li class="user-nav__orcid-publications">
        <LinkTo @route="user.orcidPublications" @model={{@outletArgs.model}}>
          {{icon "book"}}
          {{i18n "discourse_orcid_publications.tab_title"}}
        </LinkTo>
      </li>
    {{/if}}
  </template>
}
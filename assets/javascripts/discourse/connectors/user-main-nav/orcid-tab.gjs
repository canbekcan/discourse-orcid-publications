import Component from "@glimmer/component";
import { LinkTo } from "@ember/routing";
// DÜZELTİLEN SATIR: Helper'ı Discourse standartlarında dahil ediyoruz.
import i18n from "discourse-common/helpers/i18n"; 
import icon from "discourse-common/helpers/d-icon";

export default class OrcidTab extends Component {
  get hasOrcid() {
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
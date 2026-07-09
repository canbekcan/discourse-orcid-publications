import Component from "@glimmer/component";
import { LinkTo } from "@ember/routing";
import i18n from "discourse-common/helpers/i18n"; 
import icon from "discourse-common/helpers/d-icon";
import { inject as service } from "@ember/service";

export default class OrcidTab extends Component {
  @service siteSettings;

  get hasOrcid() {
    
    const user = this.args.outletArgs.model;
    const mappingConfig = this.siteSettings.orcid_connect_user_field_mappings;
    
    if (mappingConfig) {
      try {
        const mappings = JSON.parse(mappingConfig);
        const subMapping = mappings.find((m) => m.claim === "sub");
        
        if (subMapping && subMapping.user_field_id) {
          return !!user.user_fields?.[subMapping.user_field_id];
        }
      } catch (e) {
        console.error("ORCID mapping parse error:", e);
      }
    }
    return false;
  }

  <template>
    {{#if this.hasOrcid}}
      <li class="user-nav__orcid-publications">
        <LinkTo @route="user.orcidPublications" @model={{@outletArgs.model}}>
          {{icon "book"}}
          <span class="orcid-tab-text">{{i18n "discourse_orcid_publications.tab_title"}}</span>
        </LinkTo>
      </li>
    {{/if}}
  </template>
}
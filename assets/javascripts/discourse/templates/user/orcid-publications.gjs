import OrcidPublicationsList from "../../components/orcid-publications-list";

const UserOrcidPublicationsTemplate = <template>
  <OrcidPublicationsList @publications={{@model.publications}} />
</template>;

export default UserOrcidPublicationsTemplate;
<script lang="js">
import Session  from '@/shared/services/session';
import Records  from '@/shared/services/records';
import EventBus from '@/shared/services/event_bus';
import Gravatar from 'vue-gravatar';
import { capitalize } from 'lodash-es';
import AppConfig from '@/shared/services/app_config';
import Flash   from '@/shared/services/flash';

export default {
  components: { Gravatar },
  data() {
    return {
      user: Session.user().clone(),
      providers: AppConfig.identityProviders,
      uploading: false,
      progress: 0,
      previous_uploaded_avatar: undefined
    };
  },
  methods: {
    capitalize,
    iconClass(provider) {
      return "mdi-" + ((provider === 'saml') ? 'key-variant' : provider);
    },

    providerColor(provider) {
      switch (provider) {
        case 'facebook': return '#3b5998';
        case 'google': return '#dd4b39';
        case 'slack': return '#e9a820';
        default:
          return this.$vuetify.theme.themes.light.primary;
      }
    },

    selectProvider(provider) {
      window.location = `${provider.href}?back_to=${window.location.href}`;
    },

    selectFile() {
      this.$refs.fileInput.click();
    },

    uploadFile() {
      this.uploading = true;
      Records.users.remote.onUploadSuccess = response => {
        Records.importJSON(response);
        EventBus.$emit('updateProfile');
        EventBus.$emit('closeModal');
        this.uploading = false;
      };
      Records.users.remote.upload('upload_avatar', this.$refs.fileInput.files[0], {}, args => { return this.progress = (args.loaded / args.total) * 100; });
    },

    submit(kind) {
      this.user.avatarKind = kind;
      Records.users.updateProfile(this.user).then(() => {
        Flash.success('profile_page.messages.picture_changed');
        EventBus.$emit('updateProfile');
        EventBus.$emit('closeModal');
      }).catch(() => true);
    }
  },

  created() {
    Records.users.saveExperience("changePicture");
    Records.users.fetch({path: 'avatar_uploaded'}).then(res => {
      this.previous_uploaded_avatar = res.avatar_uploaded; 
    });
  }
};

</script>
<template lang="pug">
v-card.change-picture-form
  v-overlay(:value="uploading")
    v-progress-circular(size="64" :value="progress")
  v-card-title
    h1.headline(tabindex="-1" v-t="'change_picture_form.title'")
    v-spacer
    dismiss-modal-button
  v-card-text
    p.text--secondary(v-html="$t('change_picture_form.helptext')")
    v-list.change-picture-form__options-list
      v-list-item.change-picture-form__option(@click='selectFile()')
        v-list-item-avatar
          v-icon mdi-camera
        v-list-item-title(v-t="'change_picture_form.use_uploaded'")
          input.hidden.change-picture-form__file-input(type="file" ref="fileInput" @change='uploadFile' accept="image/png, image/jpeg, image/webp")
      v-list-item.change-picture-form__option(v-if="previous_uploaded_avatar" @click="submit('uploaded')")
        v-list-item-avatar
          img(:src="previous_uploaded_avatar")
        v-list-item-title(v-t="'change_picture_form.existing_upload'")
      v-list-item(v-for="provider in providers" :key="provider.id" @click="selectProvider(provider)")
        v-list-item-avatar
          v-icon {{ iconClass(provider.name) }}
        v-list-item-title(v-t="{ path: 'change_picture_form.use_provider', args: { provider: capitalize(provider.name) } }")
      v-list-item.change-picture-form__option(@click="submit('gravatar')")
        v-list-item-avatar
          gravatar(:email='user.email' :alt='user.name' :size='128')
        v-list-item-title(v-t="'change_picture_form.use_gravatar'")
      v-list-item.change-picture-form__option(@click="submit('initials')")
        v-list-item-avatar.user-avatar
          v-avatar.user-avatar__initials--small {{user.avatarInitials}}
        v-list-item-title(v-t="'change_picture_form.use_initials'")
</template>

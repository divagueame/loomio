<script lang="js">
export default {
  props: {
    subject: Object,
    field: String
  }
};
</script>

<template lang="pug">
.lmo-validation-error
  .lmo-validation-error__message.error--text.caption(v-if="subject.errors[field]" for="field + '-error'")
    span(role="status" aria-live="polite") {{subject.errors[field].join(', ')}}
</template>
<style lang="sass">
.lmo-validation-error__message
	position: relative
	margin-top: -16px

</style>

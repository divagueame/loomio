<script lang="js">
export default {
    props: {
      event: Object,
      eventable: Object
    }
};
</script>

<template lang="pug">
section.strand-item__discussion-edited(id="'outcome-'+ eventable.id")
  strand-item-headline(:event="event" :eventable="eventable", dateTime: "event.createdAt")
  p {{event.recipientMessage}}
</template>

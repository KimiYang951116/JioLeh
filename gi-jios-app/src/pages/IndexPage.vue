<template>
  <q-page>
    <div ref="mapContainer" class="map"></div>
  </q-page>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import mapboxgl from 'mapbox-gl'
import 'mapbox-gl/dist/mapbox-gl.css'

const mapContainer = ref(null)
let map = null

mapboxgl.accessToken = 'pk.eyJ1Ijoia2ltaXlhbmciLCJhIjoiY21wMGxhbHFpMWlzdjJ4b2ZzcWo3cjY5ZCJ9.kLYgUejkShnMvdT-K3NaWw'

onMounted(() => {
  map = new mapboxgl.Map({
    container: mapContainer.value,
    style: 'mapbox://styles/kimiyang/cmp11y75m000b01s7fr3615v9',
    center: [103.8198, 1.3521],
    zoom: 11,
  })

  map.addControl(new mapboxgl.NavigationControl())
})

onBeforeUnmount(() => {
  if (map) {
    map.remove()
  }
})
</script>

<style scoped>
.map {
  width: 100vw;
  height: 100vh;
}
</style>
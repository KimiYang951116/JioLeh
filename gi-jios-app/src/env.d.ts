/* eslint-disable */

declare namespace NodeJS {
  interface ProcessEnv {
    NODE_ENV: string;
    VUE_ROUTER_MODE: 'hash' | 'history' | 'abstract' | undefined;
    VUE_ROUTER_BASE: string | undefined;
    MAPBOX_ACCESS_TOKEN: string | undefined;
  }
}

declare module 'mapbox-gl/dist/esm/mapbox-gl.js' {
  import mapboxgl from 'mapbox-gl';

  export default mapboxgl;
}

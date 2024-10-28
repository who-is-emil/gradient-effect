import * as T from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';

import fragment from './shaders/fragment.glsl';
import vertex from './shaders/vertex.glsl';

const device = {
  width: window.innerWidth,
  height: window.innerHeight,
  pixelRatio: window.devicePixelRatio
};

export default class Three {
  constructor(canvas) {
    this.canvas = canvas;

    this.time = 0;

    this.scene = new T.Scene();

    this.camera = new T.PerspectiveCamera(
      75,
      device.width / device.height,
      0.1,
      100
    );
    this.camera.position.set(0, 0, 1.5);
    this.scene.add(this.camera);

    this.renderer = new T.WebGLRenderer({
      canvas: this.canvas,
      alpha: true,
      antialias: true,
      preserveDrawingBuffer: true
    });
    this.renderer.setSize(device.width, device.height);
    this.renderer.setPixelRatio(Math.min(device.pixelRatio, 2));

    this.controls = new OrbitControls(this.camera, this.canvas);
    
    this.controls.enableRotate = false;
    this.controls.enableZoom = false;
    this.controls.enablePan = false;

    this.clock = new T.Clock();

    this.setLights();
    this.setGeometry();
    this.render();
    this.setResize();
  }

  setLights() {
    this.ambientLight = new T.AmbientLight(new T.Color(1, 1, 1, 1));
    this.scene.add(this.ambientLight);
  }

  setGeometry() {
    this.planeGeometry = new T.SphereGeometry(1.5, 32, 32);
    this.planeMaterial = new T.ShaderMaterial({
      side: T.DoubleSide,
      // wireframe: true,
      fragmentShader: fragment,
      vertexShader: vertex,
      uniforms: {
        time: { type: 'f', value: 0 } 
      },
     
    });

    this.planeMesh = new T.Mesh(this.planeGeometry, this.planeMaterial);
    // this.planeMesh.rotation.x = T.MathUtils.degToRad(0);
    // this.planeMesh.rotation.y = T.MathUtils.degToRad(0);
    this.scene.add(this.planeMesh);
  }

  render() {
    const elapsedTime = this.clock.getElapsedTime();

    // this.time += 0.0025;
    this.time += 0.005;

    this.planeMaterial.uniforms.time.value = this.time;

    this.renderer.render(this.scene, this.camera);
    requestAnimationFrame(this.render.bind(this));
  }

  setResize() {
    window.addEventListener('resize', this.onResize.bind(this));
  }

  onResize() {
    device.width = window.innerWidth;
    device.height = window.innerHeight;

    this.camera.aspect = device.width / device.height;
    this.camera.updateProjectionMatrix();

    this.renderer.setSize(device.width, device.height);
    this.renderer.setPixelRatio(Math.min(device.pixelRatio, 2));
  }
}
<pano_viewer>


	<div ref="viewer" style="width: 100%; height: 480px;" class='viewer'></div>



	<script>

		this.image_url = opts.image_url
		this.viewer = null

		launch_viewer(){
			console.log(this.refs.viewer)
			console.log(this.image_url)
			this.viewer = new ThetaViewer( this.refs.viewer);
			this.viewer.images = [this.image_url];
			this.viewer.interval = 200; // msec
			this.viewer.autoRotate = false;
			this.viewer.load();
			this.update()
		}

		kill_viewer(){
			this.refs.viewer.removeChild(this.refs.viewer.querySelector('canvas'));
			this.viewer.kill()
		}

		this.on('mount', this.parent.register_pano_viewer(this))
		// this.on('updated', this.launch_viewer)



	</script>




</pano_viewer>
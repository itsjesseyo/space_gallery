<index>

	<div class="modal {image_modal_active?'active':''}" ref='image_modal'>
		<div class="modal-overlay" onclick={hide_image_modal}></div>
		<div class="modal-container" style='width:100%;max-width:100%'>
			<div class="modal-header">
				<button class="btn btn-clear float-right" onclick={hide_image_modal}></button>
			</div>
			<div class="modal-body" style='max-height:80vh;overflow-y:initial'>
				<div class="content">
					<!-- content here -->
					<img src="{modal_image_url}" class="img-responsive"/>
				</div>
			</div>
		</div>
	</div>

	<div class="modal {pano_modal_active?'active':''}" ref='pano_modal'>
		<div class="modal-overlay" onclick={hide_pano_modal}></div>
		<div class="modal-container" style='width:100%;max-width:100%'>
			<div class="modal-header">
				<button class="btn btn-clear float-right" onclick={hide_pano_modal}></button>
			</div>
			<div class="modal-body" style='max-height:80vh;overflow-y:initial'>
				<div class="content">
					<!-- content here -->
					<pano_viewer image_url={pano_url}/>
				</div>
			</div>
		</div>
	</div>

	<div class='columns'>
		<div class='column col-4 col-xs-12'  each={items}>
			<gallery room_id={id} feet={feet} price={price} room_name={name}/>
		</div>
	</div>



	<script>

		this.image_modal_active = false
		this.pano_modal_active = false

		this.modal_image_url = null


		this.room_id = opts.room_id
		this.items = []
		this.is_loading = false
		this.can_edit = false
		this.get_data = fetchival(window.location.origin+'/api/v1/get/rooms')
		this.post_data = fetchival(window.location.origin+'/api/v1/update/rooms')
		this.delete_data = fetchival(window.location.origin+'/api/v1/delete/rooms')

		// setup_modals(){
		// 	this.image_modal = this.refs.image_modal
		// 	this.pano_modal = this.refs.pano_modal
		// }

		register_pano_viewer(viewer){
			this.pano_viewer = viewer
		}

		hide_image_modal(){
			this.image_modal_active = false
			this.update()
		}

		hide_pano_modal(){
			this.pano_modal_active = false
			this.pano_viewer.kill_viewer()
			this.update()
		}

		child_activate_image_modal(url){
			this.modal_image_url = url
			this.image_modal_active = true
			this.update()
		}

		child_activate_pano_modal(url){
			this.pano_modal_active = true
			this.update()
			this.pano_viewer.image_url = url
			this.pano_viewer.update()
			setTimeout(this.pano_viewer.launch_viewer(), 1000)
			// this.pano_viewer.launch_viewer()
			// this.pano_viewer.update()
			
			
			
		}

		hide_status(){
			this.is_loading = false
			this.update()
		}
		show_status(){
			this.is_loading = true
			this.update()
		}

		fetch_data(){
			this.show_status()
			this.get_data.get({'room_id':this.room_id}).then(this.recieved_data)
			// this.post_data.post({'name':this.text,'id':-1,'price':0}).then(this.fetch_data())
		}

		recieved_data(data){
			if(data.status == 'good'){
				this.items = data.query
				this.update()
			}else{
				// console.log(data.status)
			}
			setTimeout(this.hide_status, 12)
		}

		this.on('mount', this.fetch_data())
		// this.on('updated', this.setup_modals());

	</script>


</index>
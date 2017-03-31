<gallery>


	<style type="text/css">
		div.image_div a:hover{
			cursor:pointer;
		}
		div.pano_div a:hover{
			cursor:pointer;
			background-color:black;
		}
		div.pano_div a:hover img, div.image_div a:hover img{
			background-color: #ddd;
		}
	</style>

	<div class="panel">
		<div class="panel-header">
			<div class="panel-title text-center">{name}</div>
		</div>
		<div class="panel-nav">
			<ul class='tab tab-block'>
				<li class='tab-item {show_info ? 'active' : ''}'><a onclick={show_info}>Info</a></li>
				<li class='tab-item {show_images ? 'active' : ''}'><a onclick={show_image}>Images</a></li>
				<li class='tab-item {show_panos ? 'active' : ''}'><a onclick={show_pano}>Panos</a></li>
			</ul>				
		</div>
		<div class="panel-body">
			<!-- contents -->

			<div class='info_div' show={show_info} >
				<table class="table table-striped table-hover" style='margin-top:60px'>
					<tbody>

						<tr >
							<td>name</td>
							<td>{name}</td>
						</tr>
						<tr >
							<td>price</td>
							<td>${price}</td>
						</tr>
						<tr >
							<td>sq feet</td>
							<td>{feet}</td>
						</tr>

					</tbody>
				</table>
			</div>

			<div class='image_div' show={show_images} each={images}>
				<a>
					<img src="{image_root+filename}" class="img-responsive" style='padding:2px;margin-top:16px' onclick={enlarge_image}/>
				</a>
			</div>

			<div class='pano_div' show={show_panos} each={panos}>
				<a>
					<img src="{image_root+filename}" class="img-responsive" style='padding:2px;margin-top:16px' onclick={enlarge_pano}/>
				</a>
			</div>

		</div>
		<div class="panel-footer">
			<!-- buttons or inputs -->
		</div>
	</div>

	<script>

		this.show_info = true
		this.show_images = false
		this.show_panos = false
		this.name = opts.room_name
		this.price = opts.price
		this.feet = opts.feet
		this.room_id = opts.room_id

		this.get_images = fetchival(window.location.origin+'/api/v1/get/images')
		this.get_panos = fetchival(window.location.origin+'/api/v1/get/panos')

		this.images = []
		this.panos = []


		show_info(){
			this.show_info = true
			this.show_images = false
			this.show_panos = false
		}

		show_image(){
			this.show_info = false
			this.show_images = true
			this.show_panos = false
		}

		show_pano(){
			this.show_info = false
			this.show_images = false
			this.show_panos = true
		}

		enlarge_image(event){
			this.parent.child_activate_image_modal(image_root+event.item.filename)
		}

		enlarge_pano(event){
			this.parent.child_activate_pano_modal(image_root+event.item.filename)
		}


		fetch_data(){
			this.get_images.get({'room_id':this.room_id}).then(this.recieved_images)
			this.get_panos.get({'room_id':this.room_id}).then(this.recieved_panos)
			// this.post_data.post({'name':this.text,'id':-1,'price':0}).then(this.fetch_data())
		}

		recieved_images(data){
			if(data.status == 'good'){
				this.images = data.query
				this.update();
			}else{
			}
		}

		recieved_panos(data){
			if(data.status == 'good'){
				this.panos = data.query
				this.update();
			}else{
			}
		}

		this.on('mount', this.fetch_data());



	</script>


</gallery>
			
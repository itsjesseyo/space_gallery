<upload_images>

	<div class='container'>
		<div class="columns">
			<div class='col-12'>


<div class="divider"/>
				<h1>Images</h1>

				<div class='container' style='margin-top: 1rem'>
					<div class="columns">
							<div class='col-4'></div>
							<div class='col-4'>
								<div class="loading" show={is_loading}></div>
							</div>
							<div class='col-4'>
								<!-- <div class="form-group text-right">
									<label class="form-switch">
										<input type="checkbox" onclick={ toggle_edit_mode }/>
										<i class="form-icon"></i> edit mode
									</label>
									</div>
 -->							</div>
					</div>
				</div>

				<!-- <progress class="progress" max="100"></progress> -->
				<form onsubmit={ create_new_slide } action='/upload_image' method=post enctype=multipart/form-data >
					<div class="input-group">
						<input ref="input" type="file" class="form-input" name='file'>
						<input type='hidden' name='room_id' value='{room_id}'>
						<button class="btn btn-primary input-group-btn btn-lg" style="min-width:120px">Upload</button>
					</div>
				</form>

			<div class='columns'>
				<div class="column col-3 col-xs-12" each={items} style='margin-top: 1rem;' >

					<div class="card" style='padding:8px;background-color:#f6f6f6;margin-top:12px'>
						<div class="card-image">
							<img src="{image_root+filename}" class="img-responsive" />
						</div>
					</div>

				</div>
			</div>
		

			</div><!--end column 8-->

		</div><!--end all columns -->
	</div><!--end container-->


<script>

		this.room_id = opts.room_id
		this.items = []
		this.is_loading = false
		this.can_edit = false
		this.get_data = fetchival(window.location.origin+'/api/v1/get/images')
		this.post_data = fetchival(window.location.origin+'/api/v1/update/images')
		this.delete_data = fetchival(window.location.origin+'/api/v1/delete/images')

		toggle_edit_mode(e){
			this.can_edit = e.target.checked
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
				this.items = data.query.sort(compare_order);
				this.update();
			}else{
				// console.log(data.status)
			}
			setTimeout(this.hide_status, 1000)
		}

		delete_slide(e){
			this.delete_data.post(e.item).then(this.fetch_data())
		}

		save_slide_changes(){
			this.show_status()
			this.post_data.post(this.items).then(setTimeout(this.hide_status, 1000))
		}

		set_delayed_update(item){
			clearTimeout(this.delayed_update)
			this.delayed_update = setTimeout(this.save_slide_changes, 1000)
		}

		decrement_slide(e){
			var swap_item = this.items[this.items.length - e.item.order]
			var swap_order = swap_item.order
			swap_item.order = e.item.order
			e.item.order = swap_order
			this.items = this.items.sort(compare_order)
			this.update()
			this.set_delayed_update()
		}

		increment_slide(e){
			var swap_item = this.items[this.items.length - e.item.order-2]
			var swap_order = swap_item.order
			swap_item.order = e.item.order
			e.item.order = swap_order
			this.items = this.items.sort(compare_order)
			this.update()
			this.set_delayed_update()
		}

		create_new_slide(e){
			
		}

		this.on('mount', this.fetch_data());

	</script>

</upload_images>
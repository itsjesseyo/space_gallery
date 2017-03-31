<slides>

	<div class='container'>
		<div class="columns">
			<div class='col-12'>

				<div class='container' style='margin-top: 1rem'>
					<div class="columns">
							<div class='col-4'></div>
							<div class='col-4'>
								<div class="loading" show={is_loading}></div>
							</div>
							<div class='col-4'>
								<div class="form-group text-right">
									<label class="form-switch">
										<input type="checkbox" onclick={ toggle_edit_mode }/>
										<i class="form-icon"></i> edit mode
									</label>
									</div>
							</div>
					</div>
				</div>

				<div class="divider"/>
				<!-- <progress class="progress" max="100"></progress> -->
				<form onsubmit={ create_new_slide } method=post enctype=multipart/form-data >
					<div class="input-group">
						<input ref="input" type="file" class="form-input" name='file'>
						<input type='hidden' name='count' value='{items.length}'>
						<button class="btn btn-primary input-group-btn btn-lg" style="min-width:120px">Upload</button>
					</div>
				</form>
				<div class="divider"/>

				<div class="input-group" each={items} style='margin-top: 1rem'>

					<div class="card" style='padding:8px;background-color:#f6f6f6;margin-top:12px'>
						<div class="card-image">
							<img src="{image_root+filename}" class="img-responsive" />
						</div>

						<div class="card-footer">
							<div class="btn-group btn-group-block">
								<button class="btn btn-primary btn-lg" show={can_edit} onclick={delete_slide}><i class='icon icon-cross'/> delete</button>
								<button class="btn btn-primary btn-lg" onclick={decrement_slide} show={order>0}><i class='icon icon-arrow-down' /> Move Down</button>
								<button class="btn btn-primary btn-lg" onclick={increment_slide} show={order<this.items.length-1}><i class='icon icon-arrow-up' /> Move Up</button>
							</div>
						</div>

					</div>

				</div>
		

			</div><!--end column 8-->

		</div><!--end all columns -->
	</div><!--end container-->


<script>
		this.items = []
		this.is_loading = false
		this.can_edit = false
		this.get_data = fetchival(window.location.origin+'/api/v1/get/slides')
		this.post_data = fetchival(window.location.origin+'/api/v1/update/slides')
		this.delete_data = fetchival(window.location.origin+'/api/v1/delete/slides')

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
			this.get_data.get().then(this.recieved_data)
		}

		recieved_data(data){
			if(data.status == 'good'){
				this.items = data.query.sort(compare_order);
				console.log(this.items)
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

</slides>
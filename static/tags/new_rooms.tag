<new_rooms>

	<div class='container' style='    margin-top: 1rem'>
		<div class="columns">
				<div class='col-4'>
				</div>
				<div class='col-4'>
					<div class="loading" show={is_loading}></div>
				</div>
				<!-- <div class='col-4'>
					<div class="form-group text-right">
						<label class="form-switch">
							<input type="checkbox" onclick={ toggle_edit_mode }/>
							<i class="form-icon"></i> edit mode
						</label>
				  	</div>
				</div> -->
		</div>
	</div>

	<div class='container'>
		<div class="columns">
			<div class='col-12'>

				<!-- <progress class="progress" max="100"></progress> -->
		<form onsubmit={ add }>
			<div class="input-group">
	    		<input ref="input" type="text" class="form-input input-lg" onkeyup={ edit_name } placeholder="new room name">
	    		<button class="btn btn-primary input-group-btn btn-lg" style="min-width:80px" onclick={ save_new_stat }>Add</button>
	    	</div>
	  	</form>

	  	<div  each={items} >
	  		<h3>{name}<h3>
		  	<div  class="input-group" style='margin-top: 1rem'>
				<span class="input-group-addon addon-lg" style='min-width:120px'>price</span>
				<input type="number" class="form-input input-lg" placeholder="price" onkeyup={edit_price} value={price}/>
			</div>
			<div  class="input-group" style='margin-top: 1rem'>
				<span class="input-group-addon addon-lg" style='min-width:120px'>sq feet</span>
				<input type="number" class="form-input input-lg" placeholder="feet" onkeyup={edit_feet} value={feet}/>
			</div>

			<upload_images room_id={id}/>

			<upload_panos room_id={id}/>

	  	</div>
		
		
		
		

</div>
	</div></div>

	<script>

		this.is_loading = false
		this.can_edit = false
		this.get_data = fetchival(window.location.origin+'/api/v1/get/rooms')
		this.post_data = fetchival(window.location.origin+'/api/v1/update/rooms')
		this.delete_data = fetchival(window.location.origin+'/api/v1/delete/rooms')

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
				console.log(data.query)
				this.items = data.query.sort(compare_id);
				this.update();
			}else{
				// console.log(data.status)
			}
			setTimeout(this.hide_status, 1000)
		}

		delete_stat(e){
			this.delete_data.post(e.item).then(this.fetch_data())
		}

		update_item(){
			this.show_status()
			this.post_data.post(this.item_to_update).then(setTimeout(this.hide_status, 1000))
			this.item_to_update = null
		}

		set_delayed_update(item){
			if(this.item_to_update && this.item_to_update.id == item.id){
				clearTimeout(this.delayed_update)
			}
			this.delayed_update = setTimeout(this.update_item, 1000)
			this.item_to_update = item
		}

		edit_price(e){
			console.log(e.item)
			e.item.price = e.target.value
			this.set_delayed_update(e.item)
			this.update()
		}
		edit_feet(e){
			e.item.feet = e.target.value
			this.set_delayed_update(e.item)
			this.update()
		}

		edit_name(e){
			this.text = e.target.value
		}

		add(e){
			e.preventDefault()
			if(this.text){
				this.post_data.post({'name':this.text,'id':-1,'price':0, 'feet':0}).then(this.fetch_data())
				this.text = this.refs.input.value = ''
			}
		}

		this.on('mount', this.fetch_data());

	</script>

</new_rooms>



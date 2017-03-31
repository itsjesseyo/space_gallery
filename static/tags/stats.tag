<stats>

	<div class='container' style='    margin-top: 1rem'>
		<div class="columns">
				<div class='col-4'>
				</div>
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

	<div class='container'>
		<div class="columns">
			<div class='col-12'>

		<div class="input-group" each={items} style='    margin-top: 1rem'>
			<button show={can_edit} class="btn btn-primary input-group-btn btn-lg" style="min-width:60px;margin-right:6px" onclick={ delete_stat }>delete</button>
			<span class="input-group-addon addon-lg" style='min-width:120px'>{name}</span>
			<input type="number" class="form-input input-lg" placeholder="enter a number" onkeyup={edit_item} value={value}/>
			<button class="btn btn-primary input-group-btn btn-lg" style="min-width:45px" onclick={ decrement_stat }><i class='icon icon-minus'/></button>
			<button class="btn btn-primary input-group-btn btn-lg" style="min-width:45px" onclick={ increment_stat }><i class='icon icon-plus'/></button>
		</div>
		
		<div class="divider"></div>
		<!-- <progress class="progress" max="100"></progress> -->
		<form onsubmit={ add }>
			<div class="input-group">
	    		<input ref="input" type="text" class="form-input input-lg" onkeyup={ edit_name } placeholder="new animal">
	    		<button class="btn btn-primary input-group-btn btn-lg" style="min-width:80px" onclick={ save_new_stat }>Add</button>
	    	</div>
	  	</form>

</div>
	</div></div>

	<script>

		this.is_loading = false
		this.can_edit = false
		this.get_data = fetchival(window.location.origin+'/api/v1/get/stats')
		this.post_data = fetchival(window.location.origin+'/api/v1/update/stats')
		this.delete_data = fetchival(window.location.origin+'/api/v1/delete/stats')

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
				this.items = data.query;
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

		edit_item(e){
			e.item.value = e.target.value
			this.set_delayed_update(e.item)
			this.update()
		}

		decrement_stat(e){
			e.item.value = e.item.value - 1
			this.set_delayed_update(e.item)
			this.update()
		}

		increment_stat(e){
			e.item.value = e.item.value + 1
			this.set_delayed_update(e.item)
			this.update()
		}

		edit_name(e){
			this.text = e.target.value
		}

		add(e){
			e.preventDefault()
			if(this.text){
				this.post_data.post({'name':this.text, 'value':-1, 'id':-1}).then(this.fetch_data())
				this.text = this.refs.input.value = ''
			}
		}

		this.on('mount', this.fetch_data());

	</script>

</stats>
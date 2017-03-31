<settings>

	<div class='container'>
		<div class="columns">
			<div class='col-12'>

				<div class='container' style='margin-top: 1rem'>
					<div class="columns">
							<div class='col-4'/>
							<div class='col-4'>
								<div class="loading" show={is_loading}></div>
							</div>
							<div class='col-4'/>
					</div>
				</div>

				<form class="form-horizontal">
					<div class="form-group">
						<div class="col-12">
							<label class="form-switch">
								<input type="checkbox" onclick={ show_stat_did_change } checked={this.items.auto_show_stat_on_change}/>
								<i class="form-icon"></i> Show Stats immediately after change to slides or stat settings
							</label>
						</div>
					</div>
					<div class="input-group" style='    margin-top: 1rem'>
						<span class="input-group-addon addon-lg" style='min-width:120px'>Slide Duration</span>
						<input type="number" class="form-input input-lg" placeholder="enter a number" onkeyup={slide_duration_did_change} value={this.items.slide_duration}/>
					</div>
					<div class="input-group" style='    margin-top: 1rem'>
						<span class="input-group-addon addon-lg" style='min-width:120px'>Stats Every</span>
						<input type="number" class="form-input input-lg" placeholder="number" onkeyup={adoption_stats_did_change} value={this.items.stat_frequency}/>
						<span class="input-group-addon addon-lg" style='min-width:120px'>slide(s)</span>
					</div>
				</form>






			</div><!--end column 8-->

		</div><!--end all columns -->
	</div><!--end container-->


	<script>

	this.items = {
		auto_show_stat_on_change:false,
		slide_duration:0,
		stat_frequency:0
	}

		this.is_loading = false
		this.get_data = fetchival(window.location.origin+'/api/v1/get/settings')
		this.post_data = fetchival(window.location.origin+'/api/v1/update/settings')
		this.delete_data = fetchival(window.location.origin+'/api/v1/delete/settings')

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
				this.items = data.query
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

		save_settings(){
			this.show_status()
			this.post_data.post(this.items).then(setTimeout(this.hide_status, 1000))
		}

		set_delayed_update(item){
			clearTimeout(this.delayed_update)
			this.delayed_update = setTimeout(this.save_settings, 1000)
		}

		show_stat_did_change(event){
			this.items.auto_show_stat_on_change = event.target.checked
			this.set_delayed_update()
		}

		slide_duration_did_change(event){
			this.items.slide_duration = event.target.value
			this.set_delayed_update()
		}

		adoption_stats_did_change(event){
			this.items.stat_frequency = event.target.value
			this.set_delayed_update()
		}



		create_new_slide(e){
			
		}

		this.on('mount', this.fetch_data());

	</script>

</settings>
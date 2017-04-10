<x-stream-indicator>
	<p if={ stream.state == 'initializing' }>
		<i class="fa fa-spinner fa-spin"></i>
		<span>Connecting...</span>
	</p>
	<p if={ stream.state == 'reconnecting' }>
		<i class="fa fa-spinner fa-spin"></i>
		<span>Recconecting...</span>
	</p>
	<p if={ stream.state == 'connected' }>
		<i class="fa fa-check"></i>
		<span>Connected</span>
	</p>
	<style>
		:scope
			display block
			pointer-events none
			position fixed
			z-index 10000
			bottom 8px
			right 8px
			margin 0
			padding 6px 12px
			font-size 0.9em
			color #fff
			background rgba(0, 0, 0, 0.8)
			border-radius 4px

			> p
				display block
				margin 0

				> i
					margin-right 0.25em

	</style>
	<script>
		import anime from 'animejs';

		this.mixin('stream');

		this.on('before-mount', () => {
			if (this.stream.state == 'connected') {
				this.root.style.opacity = 0;
			}
		});

		this.stream.on('_connected_', () => {
			this.update();
			setTimeout(() => {
				anime({
					targets: this.root,
					opacity: 0,
					easing: 'linear',
					duration: 200
				});
			}, 1000);
		});

		this.stream.on('_closed_', () => {
			this.update();
			anime({
				targets: this.root,
				opacity: 1,
				easing: 'linear',
				duration: 100
			});
		});
	</script>
</x-stream-indicator>

package ru.kutu.grindplayer.views.mediators {
	
	import flash.events.TimerEvent;
	
	import org.osmf.events.BufferEvent;
	import org.osmf.events.MetadataEvent;
	import org.osmf.media.MediaElement;
	
	import ru.kutu.grind.views.mediators.BufferInfoBaseMediator;
	
	public class BufferInfoMediator extends BufferInfoBaseMediator {
		
		private var isAdvertisement:Boolean;
		
		public function BufferInfoMediator() {
			super();
		}
		
		override protected function processMediaElementChange(oldMediaElement:MediaElement):void {
			super.processMediaElementChange(oldMediaElement);
			if (oldMediaElement) {
				oldMediaElement.metadata.removeEventListener(MetadataEvent.VALUE_ADD, onMetadataChange);
				oldMediaElement.metadata.removeEventListener(MetadataEvent.VALUE_CHANGE, onMetadataChange);
				oldMediaElement.metadata.removeEventListener(MetadataEvent.VALUE_REMOVE, onMetadataChange);
			}
			if (media) {
				media.metadata.addEventListener(MetadataEvent.VALUE_ADD, onMetadataChange);
				media.metadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMetadataChange);
				media.metadata.addEventListener(MetadataEvent.VALUE_REMOVE, onMetadataChange);
			}
		}
		
		override protected function onBufferChangeTimer(event:TimerEvent):void {
			if (isAdvertisement) return;
			super.onBufferChangeTimer(event);
		}
		
		override protected function onBufferingChange(event:BufferEvent):void {
			if (isAdvertisement) return;
			super.onBufferingChange(event);
		}
		
		private function onMetadataChange(event:MetadataEvent):void {
			if (event.key != "Advertisement") return;
			isAdvertisement = event.type != MetadataEvent.VALUE_REMOVE;
			if (isAdvertisement && event.value && event.value is Array && event.value.length) {
				isAdvertisement = false;
				for each (var item:Object in event.value) {
					if ("isAdvertisement" in item) {
						isAdvertisement ||= item.isAdvertisement;
						if (isAdvertisement) break;
					}
				}
			}
			if (isAdvertisement) {
				view.data = null;
			}
		}
		
	}
	
}

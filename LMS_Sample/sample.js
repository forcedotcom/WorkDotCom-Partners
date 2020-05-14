import { LightningElement, wire, track } from 'lwc';
import { subscribe, MessageContext, unsubscribe, APPLICATION_SCOPE } from 'lightning/messageService';

/*** Message Channel ***/
import COMMAND_CENTER_MSG_CHANNEL from '@salesforce/messageChannel/lightning__CommandCenterMessageChannel';

export default class lwc_component extends LightningElement{
    @wire(MessageContext)
    messageContext;
    
    @track globalLocationName;
    @track globalLocationId;
    
    subscription;

    connectedCallback() {
        this.subscribeToChannel();
    }

    /**
     * Subscribe to Command Center Message Channel to listen to global filter changes
     */
    subscribeToChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(this.messageContext, COMMAND_CENTER_MSG_CHANNEL, message => this.handleEvent(message), {
                scope: APPLICATION_SCOPE
            });
        }
    }

    /**
     * Any time global filter changes are captured get updated values
     * @param  {} message
     */
    handleEvent(message) {
        switch (message.EventType) {
            case 'CC_LOCATION_CHANGE': {
                /* This event returns two attributes within it's EventPayload (locationName & locationId) */
                this.globalLocationName = message.EventPayload.locationName;
                this.globalLocationId = message.EventPayload.locationId;
          
                break;
            }

            default: {
                break;
            }
        }
    }
    
    /**
     * If disconnected unsubscribe from Message Channel
     */
    disconnectedCallback() {
        if (this.subscription) {
            unsubscribe(this.subscription);
        }
    }
}

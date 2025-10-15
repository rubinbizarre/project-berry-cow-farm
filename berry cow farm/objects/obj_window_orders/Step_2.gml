// Refresh cards at END of step, after all clicks are processed
if (needs_card_refresh) {
    create_order_cards();
    needs_card_refresh = false;
}
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["booking", "modal"]

  connect() {
    console.log("5")
  }

  appear() {
    // console.log();
    if (this.modalTarget.style.display === "none") {
      this.modalTarget.style.display = "block";
      const bookingInfo = `<div class="container">
                          <a href="/events/${this.bookingTarget.dataset.eventid}">
                            <h6>${this.bookingTarget.dataset.title}</h6>
                            <p>Location: ${this.bookingTarget.dataset.location}</p>
                            <p>Start time: ${this.bookingTarget.dataset.date}</p>
                            <p>Number of people: ${this.bookingTarget.dataset.people}</p>
                            <p>Total price: ${new Intl.NumberFormat('ja-JP', { style: 'currency', currency: 'GBP' }).format(this.bookingTarget.dataset.price)}</p>
                          </a>
                          <a href="/users/${this.bookingTarget.dataset.userid}">
                            <p>Individual who booked: ${this.bookingTarget.dataset.userbooked}</p>
                          </a>
                    </div>`
      this.modalTarget.innerHTML = bookingInfo;
      this.modalTarget.scrollIntoView(true)
    } else {
      window.scrollTo({ top: 0, behavior: 'smooth' })
      this.timeout = setTimeout(() => (
        this.modalTarget.style.display = "none"
      ), 200);
    }
  }
}

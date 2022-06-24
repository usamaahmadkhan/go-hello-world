package hello

import "testing"

func TestHello(t *testing.T) {
	expected := "Hire Me. Kubermatic!"
	if result := Hello(); result != expected {
		t.Errorf("Hello() = %q, want %q", result, expected)
	}
}

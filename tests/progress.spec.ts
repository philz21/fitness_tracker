import { test, expect } from '@playwright/test';


test.describe('Progress chart', () => {
  test.beforeEach(async ({ request ,page }) => {
    await request.post('/test/cleanup');
    await page.goto('/');

    // First Bench Session
    await page.getByLabel('Date').fill('2025-12-01');
    await page.getByLabel('Exercise').fill('Bench Press');
    await page.getByLabel('Sets').fill('3');
    await page.getByLabel('Reps').fill('8');
    await page.getByLabel('Weight (kg)').fill('65');
    await page.getByRole('button', { name: 'Save workout' }).click();

    // Second Bench session
    await page.getByLabel('Date').fill('2025-12-05');
    await page.getByLabel('Exercise').fill('Bench Press');
    await page.getByLabel('Sets').fill('3');
    await page.getByLabel('Reps').fill('8');
    await page.getByLabel('Weight (kg)').fill('85');
    await page.getByRole('button', { name: 'Save workout' }).click();

    // Third bench session (lighter)
    await page.getByLabel('Date').fill('2025-12-10');
    await page.getByLabel('Exercise').fill('Bench Press');
    await page.getByLabel('Sets').fill('3');
    await page.getByLabel('Reps').fill('8');
    await page.getByLabel('Weight (kg)').fill('75');
    await page.getByRole('button', { name: 'Save workout' }).click();
  });

  test('shows filtered chart for a single exercise', async ({ page }) => {
    await page.goto('/progress');

    // Select Bench Press from dropdown
    await page.getByLabel('Filter by exercise').selectOption('Bench Press');
    await page.getByRole('button', { name: 'Apply filter' }).click();

    // Check that the subtitle updates
    await expect(page.getByText('Showing progress for Bench Press')).toBeVisible();

     const chartContainer = page.locator('div[id^="chart-"]');

    // Check that chart container exists
    await expect(chartContainer).toBeVisible();
    await expect(chartContainer.locator('svg')).toBeVisible();
  });
});